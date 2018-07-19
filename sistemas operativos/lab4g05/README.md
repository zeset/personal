# XV6 Filesystem UNIX-like #

## **¿Cómo está formado el filesystem de XV6?** ##

El FS de XV6 sigue un formato similar al de UNIX. Tiene un **root directory**, donde todos los demás directorios o dispositivos se montan en él. Utiliza la idea de los **[inodes](file.h)** para almacenar los metadatos de los archivos, tales como su tamaño, número de inodo, direcciones de los bloques que está utilizando para almacenar los datos, etc.

```
#!c
struct inode {
  uint dev;           // Device number
  uint inum;          // Inode number
  int ref;            // Reference count
  struct sleeplock lock;
  int flags;          // I_VALID

  short type;         // copy of disk inode
  short major;
  short minor;
  short nlink;
  uint size;
  uint addrs[NDIRECT+1];
};
```

Cabe destacar que **el nombre del archivo no pertenece al inodo**, sino, funciona como **un puntero hacia el inodo que contiene toda la información necesaria**. 
## **Características particulares del FS de XV6** ##

A continuación mencionaremos las características de dicho sistema, con el fin, de no explicarlas más adelante. Estas son:

1. Tamaño de cada bloque: 512 Bytes

2. Cantidad de inodos: 200 

3. Numero de inodo del root directory: 1

4. IPB - Inodes per block: 8

5. Bloques directos: 12

6. Bloques indirectos: 1 (Es un bloque que contiene numeros de bloques utilizados por el archivo. Caben hasta 128 numeros de bloques.)

El propósito de este proyecto es implementar **permisos de acceso a un archivo**, puesto que xv6 carece de este atributo. Si bien la implementación que se realizó es fácilmente alterable desde el espacio de usuario, se asemeja la idea de esto.

### ¿Que cosas se tuvieron que modificar? ###

Para empezar con la implementación de los permisos, se optó por **quitar 3 bits al campo MINOR**, puesto que no le hacía falta, y se le **fueron otorgados a la variable, que definimos, PERMISSION**. Con la idea de que dicha variable tenga un bit que represente al permiso de lectura, el siguiente al de escritura, y al último al de ejecución. 
Estos cambios fueron hechos en la estructura del inode en el disco, fs.h, y también en la estructura del inode en memoria, file.h. Este último es una copia de la estructura del inodo en el disco.


```
#!c

struct inode {
  ...
  short minor:13;
  ushort permission : 3;
  ...
};

struct dinode {
  ...
  short minor:13;          // Minor device number (T_DEV only)
  ushort permission : 3;
  ...
};
```

Posteriormente, se definieron las siguientes constantes que nos servirán como **[máscaras de bits.](xv6/flags.h)**

```
#!c
#define S_IREAD 4
#define S_IWRITE 2
#define S_IEXEC 1

```

Luego de realizar esto, se empezó a desglosar gran parte del filesystem para entenderlo mejor. Explicaremos brevemente algunas funciones para luego hacer la unión de todo.

Este FS, como todos, contienen un [superblock](fs.h) donde está almacenada la cantidad de inodes, cantidad de bloques, tamaño del FS, etc.

```
#!c
struct superblock {
  uint size;         // Size of file system image (blocks)
  uint nblocks;      // Number of data blocks
  uint ninodes;      // Number of inodes.
  uint nlog;         // Number of log blocks
  uint logstart;     // Block number of first log block
  uint inodestart;   // Block number of first inode block
  uint bmapstart;    // Block number of first free map block
};
```
y sus valores son inicializados en [mkfs.c](xv6/mkfs.c)

Para crear archivos, se hace uso de la funcion **ialloc**, donde utiliza un bucle para encontrar el primer inodo libre para alojar. Cabe destacar que se utiliza un **[buffer caché](bio.c)** para los inodos. Ya que el costo de escribir/leer datos del disco duro es caro, se mantiene un pequeño cache en memoria principal. Este nuevo inodo le es asignado un tipo y se incrementa su reference counter.

Una vez creado el inodo, ya se puede escribir/leer datos en él, pero antes de ello, hay que recordar **la atomicidad**. Por eso cada inodo tiene un spinlock. Por lo tanto, para cada acción que implique trabajar sobre un inodo en memoria principal, **debe usarse la funcion ilock para adquirir el lock. Al finalizar, se debe desbloquear con iunlock**.
Otras operaciones que se realizan sobre los inodos son:

**[iget](fs.c)**: Obtiene un inodo, leído del disco a través del buffer caché;

**[iput](fs.c)**: Libera el inodo, pero antes, decrementa en 1 la cuenta de referencia del inodo hasta que el número de enlaces del archivo sea 0;

Las funciones para leer y escribir archivos corresponden a bmap, writei,readi que se explicarán brevemente y sin muchos detalles a continuación:

```
#!c
static uint bmap(struct inode *ip, uint bn)
```
Dado una estructura de un inodo y un número de bloque, si es menor a 12, se fija **en los bloques directos**. En caso que alguno de ellos no contenga una dirección de bloque, le aloja una nueva (mediante balloc). En caso que supere la cantidad de bloques directos, observa si hay espacio disponible en el bloque indirecto. En caso que en el bloque indirecto no se encuentré la información que buscamos, aloja la información en él. **Esta función devuelve una dirección de bloque**.


```
#!c
int readi(struct inode *ip, char *dst, uint off, uint n)
```
Lee los contenidos de un bloque y los almacena en un buffer


```
#!c
int writei(struct inode *ip, char *src, uint off, uint n)
```

Almacena los contenidos del buffer src en el bloque correspondiente en base al offset

Si bien hay más funciones, las principales que están relacionadas con el usuario son estas.

### **Todo muy bonito, pero, ¿Como cambio los permisos?** ###

Se implementó una función de usuario similar a **[CHMOD](xv6/sysfile.c)** de linux. A partir de dicha función, dado el path y un número entero del 0 al 7, se cambia el permiso de un archivo. Las instrucciones son simples. Una vez obtenido los parámetros (argstr para el path, argint para los permisos), se hace uso de la función namei. 
El motivo de su uso fue que este se encarga de analizar las componentes del nombre (pathname) y de leer los inodos necesarios para verificar que se trata de un nombre (pathname) correcto y que el archivo realmente existe. Posteriormente dicha función, obtiene el número de inodo (esta función solo llama a namex con unos parámetros en particular).

```
#!c
struct inode* namei(char *path)
{
  char name[DIRSIZ];
  return namex(path, 0, name);
}

```
En resumen, lo que hace namex, es buscar por los directorios el archivo. Primero obtiene la dirección del inodo mediante el CWR (current working directory) del proceso siempre que el path no sea el root directory.

```
#!c
ip = idup(proc->cwd);
```
Namex llama a skipelem, y este se encarga de copiar el siguiente path en una variable, es decir, si path es "dir1/dir2", en la variable se almacena dir2. Luego se fija, mediante dirlookup, si coincide.

Después de verificar el pathname, en sys_chmod, y una vez que se obtenga el inodo, se bloquea para poder modificar su campo de permisos. Posteriormente sera desbloqueado.


```
#!c
  ilock(ip);
  ip->permission = perms;
  iupdate(ip);
  iunlock(ip);
```

### **¿Donde se toqueteó para comprobar los permisos? Porque solo se ven cambios en las estructuras y nada mas** ###

El permiso de ejecución es verificado en [exec](exec.c).


```
#!c
  if((ip = namei(path)) == 0 || (getting_perm(ip) & S_IEXEC) == 0 ){
    end_op();
    return -1;
  }
```
Se creó la función "getting_perm", por comodidad, que devuelve el permiso del inodo. Se encuentra en **[fs.c](fs.c)**

```
#!c
int
getting_perm(struct inode *ip)
{
  int perms;
  begin_op();
  ilock(ip);
  perms = ip->permission;
  iunlock(ip);
  end_op();  
  return perms;
}
```

Pero **los permisos de escritura y lectura** se verifican en la función open. Esta llamada, al igual que creat, dup o link, permite el acceso a datos del archivo y devuelve un descriptor de archivo. Este es un índice que sirve para acceder a las entradas de la tabla de archivos (una estructura global del kernel y en ella hay una entrada por cada archivo distinto). 
Los procesos van a acceder a los archivos manipulando su descriptor asociado, que es un número. Cuando un proceso invoca una llamada para realizar una operación sobre un archivo, le va a pasar al kernel, el descriptor de ese archivo.

Cuando se utiliza open con el flag de "O_CREATE" se tuvieron en cuenta los siguientes aspectos:

* Si no existe el archivo, cuando se crea, mediante el uso de la función create, obtiene todos los permisos.


```
#!c
static struct inode* create(char *path, short type, short major, short minor)
...
  ilock(ip);
  ip->major = major;
  ip->minor = minor;
  ip->nlink = 1;
  ip->permission = 7;
  iupdate(ip);
...

```

* Si el archivo existe, y solo pasamos como parámetro al open "O_CREATE", solo podrá modificarse el archivo si tiene permiso total.

```
#!c

  else if(omode == O_CREATE && ip->permission < 7){
    iunlockput(ip);
    end_op();
    return -1;
  }
```

Si pasamos más de un parámetro, verificamos que si se quiso abrir un archivo en modo lectura o escritura, compruebe que los permisos del archivo sean correspondientes. Es decir, si abrimos un archivo como modo escritura/lectura, mediante una mascara de bits en el campo permisos del inodo, se verifica que tenga los permisos correspondientes.

```
#!c
  if(f->readable == 1 && (perms & S_IREAD) == 0){
    return -1;
  }
  if(f->writable == 1 && (perms & S_IWRITE) == 0){
    return -1;
  }

```

### **¿Algo más que se haya modificado?** ###

Además de hacer toda está implementación, se tuvo en cuenta que todos los archivos existentes en XV6 se les brinde todos los permisos. Esto se hace agregando esta linea de codigo en [mkfs.c](xv6/mkfs.c).


```
#!c

uint
ialloc(ushort type)
{
  uint inum = freeinode++;
  struct dinode din;

  bzero(&din, sizeof(din));
  din.type = xshort(type);
  din.nlink = xshort(1);
  din.size = xint(0);
  din.permission = xshort(7); //<----- Esta linea
  winode(inum, &din);
  return inum;
}
```


Pero no solo nos conformamos con esto, si no, que también queremos que los permisos que modifiquemos se almacenen en disco. Es por eso que en chmod se hace uso de **iupdate**. Esta función simplemente copia los contenidos del inode a una estructura dinode (destacamos que esta estructura es para el disco).
Para saber también que tipo de permisos tienen los archivos, modificamos la estructura **[stat](stat.h)** que es utilizada por la función de usuario **[ls](ls.c)**


```
#!c
struct stat {
  short type;  // Type of file
  int dev;     // File system's disk device
  uint ino;    // Inode number
  short nlink; // Number of links to file
  uint size;   // Size of file in bytes
  ushort permission : 3; // <---- Agregamos eso para copiar los permisos del inode
};
```

Lo que hicimos con LS fue agregarle el flag -l para que imprima los permisos del archivo. Su modo de uso es un tanto estricto:

* **ls -l** Es para mostrar todos los archivos con los permisos.

* **ls -l file1 file2 etc** Es para mostrar los permisos de archivos en especifico.

Siempre **se verifica que el segundo argumento sea -l**. En caso que lo sea, usamos una variable llamada show_perms, que si tiene valor 0, entonces se muestran los permisos. Para cualquier otro valor, no los muestra.


```
#!c
if(argc < 2){
    ls(".",1); //Si solo introduzco ls, no muestres los permisos
    exit();
  }
  else if(argc < 3){
    show_perms = strcmp(argv[1],"-l"); //Verifico que el segundo argumento sea -l
    ls(".",show_perms);
    exit();
  }
  else{
    show_perms = strcmp(argv[1],"-l"); //Si tengo mas de 2 argumentos, verifico que el segundo argumento sea -l
  }
  for(i=2; i<argc; i++)
    ls(argv[i],show_perms);
  exit();
}


void ls(char *path,int show_perms)
{
...
 case T_FILE:
    if(show_perms != 0){ //Si no tengo -l
      printf(1, "%s %d %d %d\n", fmtname(path), st.type, st.ino, st.size);
    }
    else{ //Si se usó -l
      printf(1, "%s %d %d %d %d\n", fmtname(path), st.type, st.ino, st.size, st.permission);
    }
    break;
...
//Lo mismo ocurre si es un directorio
```