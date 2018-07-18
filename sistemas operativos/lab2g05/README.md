### **Semaphore Implementation** ###

Para representar a los semáforos se utilizarán los índices de un arreglo previamente definido. El valor que se encuentra o asigna en ese índice (o semáforo), será incrementado o decrementado segun las circunstancias.

We we'll be using array indexes to represent semaphores. The assigned or stored value in that index (semaphore) we'll be incremented or decremented according to circumstances.

### **Function explanation** ###

Para dar inicio a este laboratorio, decidimos crear [semaphore.c](xv6/semaphore.c) y [semaphore.h](xv6/semaphore.h) para definir a las operaciones de los semáforos. Estos son sem_init, sem_release, sem_down y sem_up. A continuación, detallaremos las decisiones que fuimos tomando durante la construcción de estos archivos mencionados anteriormente.

When we were starting this proyect we created [semaphore.c](xv6/semaphore.c) and [semaphore.h](xv6/semaphore.h) to define operations between semaphores. Those are sem_init, sem_release, sem_down and sem_up. Afterwards we'll be detailing about the decisions we've been taking during the construction of the files we mentioned before.

Nuestra primera decisión, fue crear una variable candado para asegurar que solo una CPU a la vez puede examinar el semáforo. A dicha variable la nombramos semlock, creada en [semaphore.c](xv6/semaphore.c) y llamada en [main.c](xv6/main.c)

Our first move was to create a variable *'lock'* to ensure that only one CPU could check the semaphore at the same time. We named this variable *'semlock'*, it is in [semaphore.c](xv6/semaphore.c) and it's called by [main.c](xv6/main.c)

```
#!c
void semlock_init(){
  initlock(&semlock,"sem");
}
```
Para hacer uso del "semlock", utilizamos las funciones acquire() y release(). La función acquire recibe como parámetro el candado, y después de la deshabilitación de las interrupciones, utiliza una instrucción del procesador llamada xchg (ver [x86.h](xv6/x86.h). Dicha instrucción es atómica y permite que solo un proceso pueda encontrarse en la region critica. 

To use *'semlock'* we have the functions **acquire()** and **release()**. *acquire()* receives the lock as a parameter and after disabling interrupts it use a procesor's instruction called *'xchg'* (ver [x86.h](xv6/x86.h)); it is an atomic instruction that allows only one process to execute the critical section.

```
#!c
acquire(struct spinlock *lk)
{
  pushcli(); // disable interrupts to avoid deadlock.
  if(holding(lk))
    panic("acquire");

  // The xchg is atomic.
  while(xchg(&lk->locked, 1) != 0)
    ;
```
Para liberar el semlock, se debe llamar a la función **release**. Esta trabaja de manera inversa al **acquire**. Utiliza una instrucción atómica para habilitar el candado con el fin de que otro proceso puede acceder a su sección crítica, y activa las interrupciones del sistema.

To release 'semlock' we need to call the function 'release()'. It works inversely to 'acquire()', it uses an atomic instructions to free the lock so another process is able to enter the critical section, then it enables system inturrupts.

-Nuestra segunda decisión importante surgió a partir del uso de la función sleep en el sem_down.

An important decision came out about the use of 'sleep()' function in 'sem_down'.

```
#!c
void sem_down(int semaphore){
  while(total_sem[semaphore] == 0){
    sleep(&total_sem[semaphore],&semlock);
  }
  total_sem[semaphore]--;
}
```
Para mayor comprensión, explicaremos dicha función:

**Sleep**, definida en [proc.c](xv6/proc.c), toma 2 argumentos, en el cual el primero determina el canal (o lugar) donde el proceso actual va a entrar en el estado "SLEEPING".


```
#!c
proc->chan = chan;
  proc->state = SLEEPING;
  sched();
```

Se utilizó como canal la dirección de cada semáforo, con el propósito de no despertar todos los procesos, sino, a los que solicitaron el semáforo en cuestión.
El segundo argumento es el candado de exclusion mutua. Sleep toma el candado del process table para así no verse interrumpido y poder liberar el lock del argumento.

It's been used as a channel for the direction of each semaphore with the purpouse of not waking up all the proceses, but, to which requested the semaphore in question.

```
#!c
if(lk != &ptable.lock){  //DOC: sleeplock0
    acquire(&ptable.lock);  //DOC: sleeplock1
    release(lk);
  }

```
Es decir, cuando un proceso solicita un semáforo cuyo valor es 0, entonces se lo manda a "dormir". Pero antes de ser ingresado a ese estado, la función Sleep se encarga de liberar el semlock. Como consecuencia de esto puede suceder, por ejemplo, que otro proceso tome el semlock y retome la ejecución. En particular, si ese proceso solicitó el mismo semáforo, podría continuar la ejecución sin cumplir con la condición de que sea distinto a 0. Y como consecuencia, el valor empezaría a ser negativo. A partir de esto, surgió la necesidad de usar un while. 

That is to say, when a proceses requests a semaphore with the value '0', then sends it to 'sleep'. But before being entered to that state, the 'sleep()' function is responsible for freeing that lock. As a comsequence, for example, it can happen that another process take the 'semlock' and resume execution. In particular, if this process requested the same semaphore, it could resume execution without complying the condition that this semaphore were different from '0'. And as a comsequence, the value would be negative. To avoid this, we needed to use a while-loop.

```
#!c
  while(total_sem[semaphore]==0){
    sleep(&total_sem[semaphore], &semlock);
  }
  total_sem[semaphore]--;
```
De esta manera, se obliga al nuevo proceso chequear el valor del semáforo. Si el nuevo proceso solicita un semáforo que es 0, tendrá que ser "dormido" al igual del proceso anterior.

In this way, the new process is forced to check the semaphore's new value. If the new process request a semaphore that is '0', it will be put to sleep just like the previous process.

Otra decisión tomada, se debió al uso de la función **[wakeup](xv6/proc.c)**. 

Another decision is due to the use of the function **[wakeup](xv6/proc.c)**.

```
#!c
void
wakeup(void *chan)
{
  acquire(&ptable.lock);
  wakeup1(chan);
  release(&ptable.lock);
}
```
Dicha función, se encarga de cambiar el estado del proceso que se encuentra en el canal recibido como parametro, es decir, del estado SLEEPING al estado RUNNABLE, mediante el uso del lock de la process table para así poder continuar con su ejecución.

Said function is in charge of changing the state of the process inside the channel that's been received as a parameter, that is to say, from the state SLEEPING to the state RUNNABLE through the use of the lock 'process table' to continue with execution.

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
Una vez terminada la implementación de las funciones para los semáforos, tuvimos que hacer uso de la función **[argint](xv6/syscall.c)** para poder transferir argumentos de la función de usuario a las syscalls correspondientes.

Once completed the implementation of semaphore's functions, we needed to use **[argint](xv6/syscall.c)** to transfer arguments from user's function to the corresponding syscall.

```
#!c
int
argint(int n, int *ip)
{
  return fetchint(proc->tf->esp + 4 + 4*n, ip);
}
```
El primer argumento que toma la función determina a que posición del char* argv[] nos referimos y el segundo argumento es la dirección de memoria de la variable que le queremos asignar el valor del argumento.
Para lograr esta asignación hace uso de la función fetchint donde el primer argumento es **(completar que hace esta funcion)**.

The first argument that takes the function determines the position of the char* argv[] we're refering to and the second argument is the memory adress of the variable we want to assign the first argument's value.
To achieve this assignment we use the function fetchint, where the first argument is the value of the 'stack pointer'. The reason why we add 4 to this adress is because this pointer initially points to the name of the function (argument 0).

En el ejemplo proporcionado **([barrier_init.c](xv6/barrier_init.c) , [barrier_echo.c](xv6/barrier_echo.c), [barrier_rise.c](xv6/barrier_rise.c))** , se puede observar que imprime en pantalla **"zombie!"**
o que después de ejecutar uno de los procesos, imprima un "$" y haga un salto de linea.
El estado **"zombie!**" se debe a que (completar)

In the given example **([barrier_init.c](xv6/barrier_init.c) , [barrier_echo.c](xv6/barrier_echo.c), [barrier_rise.c](xv6/barrier_rise.c))**, we can see that it prints on the screen **'zombie!'** or after executing a process, it prints '$' and a line break. The *'zombie!'* state is because this process keeps apairing at the process table in the kernel. Concretely, after a 'fork()' call, if the father process finish before the child process, this one doesn't disappear completely, it remains in a state known as zombie.
To avoid this situation, it uses the function **[wait()](xv6/proc.c)** for the father process to wait for the child process to finish executing, in the case of existing. For this to happen, the father process gets block till the child process finish. Once the child process gets identified, the function sets memory (and the resources asociated) free. After substracting him from the process table, said function will return the PID (Process ID) for the child process.

Que se imprima un **$** es debido a que, luego de llamar un barrier_rise, se continua la ejecución de alguno de los procesos en segundo plano (causados por barrier_echo), por lo que el $ es el shell esperando otra función a ejecutarse pero como uno de los procesos "activados" continúa su ejecución, verifica si lo que introdujo el usuario fue múltiples argumentos, en caso afirmativo imprime un espacio en blanco, en caso negativo hace un salto de linea.

That a is **$** being printed is because, after calling *'barrier_rise'*, the execution of some proceses continues in background (caused by *'barrier_echo'*), so the $ is the *shell* waiting for another function to be executed. But because one of the 'activated' proceses continues it execution, it verifies if the user input were given in multiple arguments, if so it prints a blank space, otherwise it prints a line break.

```
#!c
for(i = 1; i < argc; i++)
    printf(1, "%s%s", argv[i], i+1 < argc ? " " : "\n");
```
### **PingPong** ###
Para crear dicho programa de usuario, tuvimos que disponer de las funciones que se encuentran en user.h. 
Explicar uso de los semáforos........

To build this user program, we needed some functions defined in user.h.
Explicar uso de los semáforos........