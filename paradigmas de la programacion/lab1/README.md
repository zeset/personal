# Laboratorio 1 - Paradigmas 2018

## Programación Orientada a Objetos con Ruby

Nahuel Borda y Paula Reyna

En este laboratorio nos fue pedido que implentasemos una aplicacion web al estilo de pedidosya, la cual fue hecha
en ruby, a traves del framwork sinatra.
En este breve informe abarcaremos cuales fueron las decisiones de diseño que se tomaron por parte de nuestro grupo.
En primer lugar hablaremos sobre el uso del metodo from_hash, el cual fue el primero planteado por la catedra
para poder contruir los objetos como usuarios, items y ordenes.
Si bien encontramos tambien otras formas de obtener los hash de los objetos que estabamos creando, nos parecio que
"hardcodear" dentro de la clase los atributos de un objeto no era lo mas eficiente, siendo que from_hash cumplia exactamente
la misma tarea. Por ende, en pos de poder reutilizar el codigo ya provisto en el esqueleto, nuestros hashes de informacion
de objetos de forman con from_hash.
Hubo, sin embargo, una salvedad dentro del codigo de from_hash, que tuvimos que omitir ya que cuando from_hash hacia un "update",
segun la definicion de esta dada por la catedra en model.rb, se chequeaba que el hash tuviese un id asignado. Sucedia que en caso, como por ejemplo
en Providers o Consumers, esa id estaba proxima a ser creada, lo que devolvia errores del tipo
 ##KeyError- The hash is not valid##
Con el fin de sortear esto, se elimino la linea que hacia esta verificacion.
Otra decision de diseño importante que hubo que tomar, hacia referencia a como borrar usuarios, ordenes o items. Encontramos muchas
dificultades para chequear si los items estaban siendo borrados, y porque cuando se reiniciaba el servidor el metodo no tenia efecto.
En pos de solucionar esto llamamos al metodo de clase save, luego de hacer cualquier tipo de cambio sobre un objeto o instancia, para asi poder 
tener todas las bases de datos actualizadas, y no encontrarnos con este tipo de problemas.
En cuanto al diseño hecho sobre las clases de la aplicacion en si, decidimos crear 4 clases, todas las cuales heredaban atributos de la clase Model.
Estas clases son items, orders, locations y users, que tenia como subclases a providers y users. Esto se hizo asi para agregar una capa mas de abstraccion sobre la idea de clases. Dentro de los archivos correspondientes a cada clase(item.rb,user.rb, location.rb y order.rb)se puede ver en mas detalle cada atributo dado a la clase y sus permisos correspondientes.
Finalmente, en cuanto al desarrollo de la api en si, tomamos la decision de escribir todo el codigo dentro del archivo app.rb. Sim embargo, como ya
se menciono antes, cada clase tiene sus atributos y su validate_hash dentro de sus archivos correspondientes.




