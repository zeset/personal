# Coreldró

En este laboratorio vamos a implementar un editor gráfico sencillo, utilizando
una API provista por la cátedra.  Esta API internamente llama a la que trae
OCaml.

Desde un punto de vista funcional, se puede entender a la aplicación como una
"máquina de estados" que va pasando de un estado a otro para completar una
cierta tarea.  Para pasar de un estado a otro, el usuario debe apretar una tecla
o el botón del mouse.

Las tareas a desarrollar son las siguientes:

| Tarea              | Paso      | Información                     | Siguiente paso     |
| ------------------ | --------- | ------------------------------- | ------------------ |
| Espera círculo     | Letra 'c' | Dibuja "Waiting for circle"     | Dibuja círculo     |
| Dibuja círculo     | Click     | Dibuja círculo de radio 5       | Espera un círculo  |
| Espera rectángulo  | Letra 'r' | Dibuja "Waiting for rectangle"  | Dibuja rectángulo  |
| Dibuja rectángulo  | Click     | Dibuja rectángulo de 10x10      | Espera rectángulo  |
| Espera borrar      | Letra 'd' | Dibuja "Waiting for deletion"   | Borra              |
| Borra              | Click     | Borra la figura(s) que incluyan al punto | Espera borrar |
| Espera selección 1 | Letra 's' | Dibuja "Waiting for 1st point of selection" | Espera selección 2 |
| Espera selección 2 | Click     | Dibuja "Waiting for 2nd point of selection" | Selecciona |
| Selecciona         | Click     | Guarda la selección             | De/Crecer selección |
| Crecer selección   | Letra '+' | Incrementa las figuras seleccionadas | Ninguno       |
| Decrecer selección | Letra '-' | Decrementa las figuras seleccionadas | Ninguno       |
| Exit               | Letra 'e' | Sale de la aplicación                | Ninguno       |


### Aclaraciones

* Dibujado: Para dibujar una figura, se toma como centro el lugar en el que el
  usuario hizo click.  Las figuras deberán estar pintadas (en la API, las
  llamadas `fill_rect` o `fill_circle`).

* Borrado: Para borrar una figura, se debe contemplar que el punto donde el
  usuario hace click esté contenido por la figura (en el caso del círculo, basta
  con tomar el rectángulo que lo incluye, no hace falta hacer geometría
  complicada).

* Selección: La selección será el rectángulo contenido por los dos puntos
  ingresados por el usuario.  Vamos a hacer dos simplificaciones:

  1. La selección podrá contener algo si los puntos fueron marcados en el orden
     correcto: primero el punto mas abajo a la izquiera, luego el punto mas arriba
     a la derecha.

  2. Una figura se considerará seleccionada si su centro se encuentra incluido en
     el rectángulo de selección.

  La API prevée la posibilidad de dibujar figuras sin relleno por si se quiere
  indicar de esta manera que una figura está seleccionada (opcional).

* De/crecido: Los círculos serán de/crecidos 2 puntos de radio, los rectángulos 4.

* En cuanto se presiona alguna tecla distinta de + o -, la selección se borra.


## Implementación

A la hora de implementar el trabajo, deben tener en cuenta lo siguiente:

* Base: La aplicación consta inicialmente de los siguientes archivos:

  - `src/app.ml`: Este módulo es el que deben completar con la aplicación.
    Proveemos un poco de esqueleto para guiarlos un poco. La interfaz
    (`app.mli`) no hace falta cambiarla.

  - `src/graphicsIntf.mli`: Nuestra interfaz para la API de dibujado.  Basada en
    `Graphics` de OCaml.

  - `src/graphicsImpl.ml` y `src/graphicsImpl.mli`: El módulo que implementa la
    interfaz `src/graphicsIntf.mli`, como redirección a `Graphics`.  Al menos
    que implementen puntos estrellas, no deben cambiar nada.

  - `src/main.ml`: Es el módulo que ejecuta la aplicación, inyectando nuestra
    API de dibujado.

* Efectos: Como este laboratorio es sobre programación funcional, sólo vamos a
  permitir como "efectos" a los de dibujar, provistos por nuestra API.  Si
  necesitan otro, deben justificarlo bien en el README.md.  Si usan una
  referencia (tipo `ref`), por mas justificado que esté, serán penalizades y
  públicamente humillades.  Las excepciones son considerados como efectos, y por
  ende, son también indeseados.  Pueden emitir excepciones si quieren marcar
  casos excepcionales que no deberían ocurrir, como en:

````
  (** Esta función espera que `o` sea `Some algo` *)
  let get_some (o : 'a option) =
    match o with
    | Some p -> p
    | _ -> failwith "get_some: se esperaba Some"
````

* Reuso de código: La programación funcional permite mucho reuso de código,
  mediante las funciones de alto orden.  ¡Hagan uso de ellas!  En particular, si
  se encuentran haciendo pattern-matching en una lista, seguramente se están
  olvidando de usar una función de librería.  Vean en particular las librerías
  `List` y `Pervasives`.

* Modularización: Creen los tipos de datos que sean necesarios, y vean de
  separarlos en módulos que contengan funcionalidad específica..

* Librerías: Pueden hacer uso de cualquier librería que sea instalable mediante
  opam.  En ese caso deben explicitar en el README.md qué librería debe
  instalarse para poder compilar el laboratorio.

* Casos bordes: Asegúrense que la aplicación no explota.  Más de esto en Testing.

* Flickering: No se preocupen si la imagen "flickea", es decir, si se ve
  intermitente.  Tampoco es necesario optimizar el dibujado para sólo incluir
  los cambios realizados; es perfectamente válido redibujar todo a cada paso.

* Warnings: No dejen ningún warning en el código, al menos que haya una buena
  razón (en cuyo caso deben documentarla en el README.md).

## Testing

En la carpeta `tests` encontrarán una pequeña suite de tests con algunos
ejemplos pavos.  Para ello utilizamos la librería OUnit, que se puede instalar mediante

````
$ opam install oUnit
````

Si tiene la aplicación andando, y los tests le fallan, puede ser que sea porque
hacen algo diferente a nuestra implementación.  En ese caso, modifiquen los
tests, y aclaren en el README la diferencia.

Se esperan que entreguen una suite razonable de tests propios, extendiendo los
existentes.  No hay un número preciso de tests, pero sí tienen que asegurarse de
testear toda la funcionalidad.


## Entrega

Fecha: Lunes 11 de Junio a las 7:59:59
Deberán crear un tag indicando el release para corregir.

`git tag -a lab-3 -m 'Entrega Laboratorio 3' && git push --tags`

**Si no está el tag no se corrige**. Tampoco se consideran commits posteriores
al tag.

El laboratorio debe contener únicamente las carpetas y archivos indicados:

  - Carpeta `src`: El código (puede contener sub-carpetas si lo desean).  Sólo debe
    contener archivos .mli o .ml.

  - Carpeta `tests`: Los archivos de testing (.ml y .mli).

  - Archivo `README.md`: Debe explicitar las decisiones de diseño que tomaron, y
    aquellas modificaciones que hicieron al código original.

  - Archivo `CONSIGNAS.md`: Este archivo.

  - Archivo `Makefile`: Archivo para compilar.
    `make`: compila la aplicación, dejando el archivo `bin/coreldro`.
    `make clean`: elimina todos los archivos de compilación.
    `make test`: compila y ejecuta los tests.

Cualquier otro archivo será considerado basura al menos que expliciten en el
README.md la razón para incluirlo.

Durante la compilación, se crea el archivo `bin/coreldro` con la aplicación.
Esta carpeta, y su contenido, no deben ser parte de la entrega (no lo suban a
bitbucket!).

## Estilo de código

No vamos a requerir el uso de un linter específico, pero sí que el código sea
legible.  Pueden usar como referencia el código provisto.  Si encontramos tabs y
espacios en un archivo vamos a enojarnos mucho (modifiquen el del código
provisto para homogeneizar con su estilo!).  Si encuentro (yo Beta) tabs o un
número menor o mayor a 2 espacios, lo voy a mirar con cierto asco, pero no será
penalizado.

## Puntos estrella

1. Se agrega la posibilidad de tener color mediante las teclas numéricas:
  1. Color negro.
  2. Color rojo.
  3. Color azul.
  4. Color verde.

2. Se agrega la posibilidad de seleccionar varias veces, haciendo crecer la
   selección en vez de reemplazando la ya existente.  Se invoca con la tecla
   'a'.

## Referencias:

1. Información básica de OCaml (antes de preguntar nada asegúrense de entender):
  - [Basics](https://ocaml.org/learn/tutorials/basics.html)
  - [Structure](https://ocaml.org/learn/tutorials/structure_of_ocaml_programs.html)
  - [Types and matching](https://ocaml.org/learn/tutorials/data_types_and_matching.html)
  - [Ifs and loops](https://ocaml.org/learn/tutorials/if_statements_loops_and_recursion.html)

2. Documentación de liberías (antes de reinventar, busquen aquí):
  - [List](https://caml.inria.fr/pub/docs/manual-ocaml/libref/List.html)
  - [Pervasives: este módulo está "abierto" por default](https://caml.inria.fr/pub/docs/manual-ocaml/libref/Pervasives.html)
  - [Graphics: de este, sólo utilizaremos lo exportado por nuestra API](https://caml.inria.fr/pub/docs/manual-ocaml/libref/Graphics.html)
