# Corrección		
	Tag o commit corregido:	lab-1
		
## Entrega		100,00%
	Tag correcto	100,00%
	En tiempo	100,00%
## Funcionalidad		100,00%
	La aplicación arranca y funciona	100,00%
	Pasa todos los tests base	100,00%
	Pasa todos los tests con errores	100,00%
	Los objetos están disponibles después de apagar el servidor	100,00%
	Si se eliminan objetos, se borran de los archivos json	100,00%
		
## Modularización y diseño		80,00%
	(Herencia) Clases User / Consumer / Provider	100,00%
	Métodos de objets (filter, index, find, all, exists) correctos y respetan encapsulamiento	100,00%
	Clases Order / Item. Location es opcional	100,00%
	(Encapsulamiento) Funciones para agregar items, calcular el costo y cambiar el estado en Order.	0,00%
	(Herencia) Funciones validate_hash en todos los objetos	100,00%
	Modelos guardados en json distintos	100,00%
## Calidad de código		76,00%
	sin estructuras redundantes	100,00%
	Líneas de más de 80 caracteres	0,00%
	Indentación	80,00%
	No subieron archivos json (además del locations.json)	100,00%
	Respetaron la estructura de directorios original	100,00%
	Modelos implementados en archivos separados	100,00%
		
		
		
## Uso de git		100,00%
	Commits frecuentes	100,00%
	Nombres de commits significativos	100,00%
	Commits de ambos integrantes	100,00%
## Opcionales		
	Rubocop	
	Puntos estrella	
		
# Nota Final		8,176
		
		
# Comentarios		
	El diseño de objetos es correcto, pero faltan métodos para incrementar la abstracción. Por ejemplo, se modifican todos los atributos desde app.rb. En particular, Order.status debería estar encapsulado. Para calcular el total de la orden también se podría usar un método particular, de forma si se modifican los items no quede un objeto inconsistente.	
	Mezclan tabs e indents	
	Comentarios por todos lados, en castellano. The best documentation is good code!	
		
