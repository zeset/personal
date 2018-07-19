## **¿Por qué el planificador de xv6 es una porquería? ** ##

XV6 utiliza el planificador **Round Robin** de manera FIFO, o sea, a todos los procesos a medida que se originan, se les asigna un tiempo fijo (un **quantum**) de ejecución. Este tiempo puede ser modificado en [lapic.c](xv6/lapic.c) en la funcion:

```
#!c
void lapicinit(void)
```
Particularmente aquí:
```
#!c
lapicw(TICR, 10000000);
```
Uno de los defectos de este planificador es que penaliza a los procesos I/O, a comparación de los procesos CPU/BOUND.

A continuación explicaremos como trabaja el planificador mencionado anteriormente:

Cabe destacar que en **[proc.h](xv6/proc.h)**, están definidos los estados que se puede hallar el proceso: UNUSED, EMBRYO, SLEEPING, RUNNABLE, RUNNING, ZOMBIE.
Además en la función allocproc, en **[proc.c](xv6/proc.c)**, se encarga de buscar en la tabla un proceso sin usar (p->state = UNUSED) y si lo encuentra, le cambia el estado a EMBRYO y lo inicializa.

```
#!c
for(p = ptable.proc; p < &ptable.proc[NPROC]; p++) //RECORRIDA POR LA TABLA DE PROCESOS
    if(p->state == UNUSED)
      goto found;
  return 0;
found:
  p->state = EMBRYO;
```
Cuando XV6 inicia, ejecuta la función **[scheduler](xv6/proc.c)** que realiza un bucle infinito hasta que se apaga el sistema. Por medio de este bucle, se recorre la tabla de procesos verificando cuales estan en el estado **READY** o **RUNNABLE**, para luego ejecutarlo. Esta función es llamada por cada CPU.

```
#!c
 acquire(&ptable.lock);
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
      if(p->state != RUNNABLE)
        continue;
```
Se puede observar que se habilitan las interrupciones para que otras CPU's puedan también buscar el proceso a correr.

Una vez que lo encuentra, marca al proceso como RUNNING y luego llama a swtch para empezar a ejecutarlo.
```
#!c
      proc = p;
      switchuvm(p);
      p->state = RUNNING;
      swtch(&cpu->scheduler, p->context);
      switchkvm();
```
La función **swtch**, definida en [swtch.S](xv6/swtch.S), guarda ciertos registros del proceso que se estaba ejecutando anteriormente y carga los registros del nuevo proceso. Este conjunto de registros son llamados **contextos** y permiten que la ejecución del proceso pueda reanudar la operación a donde se detuvo y continuar en la pila a donde se estaba trabajando. 
En sínstesis, **swtch hace el cambio de procesos.**
 
Esta función puede haber sido invocada debido a que sucedió uno de los siguientes:

1. Por la finalización del tiempo de quantum.
2. O por que el proceso desea renunciar a la CPU.

### ** ¿Como XV6 se da cuenta que pasó un quantum?** ###

El **APIC** es el encargado de generar interrupciones de sistema cuando pasa un determinado tiempo. Cuando pasa esta interrupción, se produce un [trap](xv6/trap.c)

```
#!c
if(proc && proc->state == RUNNING && tf->trapno == T_IRQ0+IRQ_TIMER)
    yield();
```

y ejecuta la función [yield()](xv6/proc.c). Este se encarga de cambiar el estado (**RUNNING**) del proceso a **RUNNABLE**, y llama a la función **shed**.
**Shed** congela temporalmente la ejecución del proceso y chequea los motivos del por que se dio la llamada. Es decir, si fue por:
1. Interrupción del temporizador.
2. Que el proceso termina su ejecución.
3. Que tiene que bloquearse para esperar un evento.

Luego, shed se encarga de invocar a swtch para que realice el cambio de contexto, es decir, dar el CPU a otro proceso que este en estado **RUNNABLE**.

```
#!c
void
yield(void)
{
  acquire(&ptable.lock);  //DOC: yieldlock
  proc->state = RUNNABLE; //CAMBIO DE ESTADO DEL PROCESO
  sched();
  release(&ptable.lock);
}
```
**sched():**

```
#!c
  intena = cpu->intena;
  swtch(&proc->context, cpu->scheduler);
  cpu->intena = intena;
```

2.
Si el proceso renuncia a la CPU, pudo haber sido porque finalizó o por que necesita un evento para poder continuar.

### **¿Si el proceso se bloqueó en la espera de un evento?** ###

Cuando el proceso debe esperar alguna entrada o recurso, se llama a la función sleep para ser dormido. Entre otras tareas que lleva a cabo, se encarga de invocar a shed. Cuando el proceso se despierta, porque puede llegar a recibir el recurso, pasa del estado **SLEEPING** a **RUNNABLE**, esperando a que el planificador lo encuentre en su recorrida infinita por la tabla de procesos una y otra vez.

```
#!c
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
    if(p->state == SLEEPING && p->chan == chan)
      p->state = RUNNABLE;
}
```
Y si el proceso termina su trabajo, se llama shed y este a swtch.

# **Implementación del planificador MLFQ(MULTILEVEL FEEDBACK QUEUE)** #

Este proyecto consiste en la modificación del scheduler de Xv6. Para ello, se empezó con asignarle, en [proc.h](xv6/proc.h), una prioridad a cada proceso. Es decir, el proceso que tiene valor 0 tiene más prioridad a ser ejecutado que aquel que tenga 1.

```
#!c
struct proc {
  int priority;
```
 
Y en proc.c, se agregaron las respectivas asignaciones en función de lo siguiente:

1. Cuando se crea un proceso, se asignó la prioridad 0.
2. Cuando se produce un paso del temporizador, se penaliza al proceso y se asigna la priodidad 1. 
3. Si un proceso se bloquea antes que se cumpla su quamtun, se eleva su nivel estableciendo su prioridad a 0.


Se observa que esta nueva implementación le da **prioridad a los procesos I/O bound.**