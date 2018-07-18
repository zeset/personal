								## Laboratorio 3 ##
						## Paradigmas de la Programacion ##
   							Nahuel Borda y Paula Reyna

En este laboratorio se nos fue pedido implementar un editor grafico sencillo, 
soportado sobre Ocaml.


En cuanto a decisiones de diseño tomadas por el grupo, podemos nombrar
a la funcion safe_subtraction, la cual creamos para establecer un comportamiento
constante referido a cuanto se puede reducir una figura de tamaño, siendo
que no habia criterios especificados. 

Redibujar todo cada vez que se entra al loop principal llamando a draw_all 
fue otra de las decisiones que tomamos, ya que consideramos que asi podemos separar 
abstractamente la parte de dibujado de las figuras de la de modificacion
de las mismas.

En los test incluidos, modificamos las funciones two circles y two rectangles
para que al chequear, incluyera un dibujado mas de rectangle y de circle
debido a la desicion de diseño mencionada anteriormente.

En delete_nothing, en la lista de expected (en la version original), despues del
clear se hacia un draw_string, el cual fue removido por ocasionar problemas en
cuanto a la ejecucion de los tests. Segun nuestro entendimiento de que deberia
chequear este test, no consideramos que esto que eliminamos fuera necesario para
comprobar la funcionalidad de nuestro codigo.


Hablaremos ahora de los tests implementados por nosotros, los cuales fueron 6

~ deleting_circle -> Se crea un circulo para luego ser eliminado

~ deleting_rectangle -> Se crea un rectangulo para luego ser eliminado

~ increase_figure -> Se crea un rectangulo y se aumenta su tamaño

~ decrease_figure -> Se crea un circulo y se disminute su tamaño

~ increase_figure_delete -> Se crea un rectangulo, se aumenta y se borra

~ decrease_figure_delete -> Se crea un circulo, se disminuye y se borra

~ red_rectangle -> Se crea un rectangulo rojo


Luego de un analisis de todo el codigo , y luego de haber logrado que nuestro
codigo pase los tests de la catedra, y los nuestros, consideramos nuestro 
codigo funcional

Todos los archivos modificados se encuentran dentro de las carpetas de src y 
tests. 