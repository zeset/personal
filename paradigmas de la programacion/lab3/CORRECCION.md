Grupo 10		
# Corrección		
	Tag o commit corregido:	lab-3
		
## Entrega y git		100.00%
	Tag correcto	100.00%
	En tiempo	100.00%
	README relevante (aclaraciones de diseño y funcionalidad)	100.00%
	Commits frecuentes	100.00%
	Nombres de commits significativos	100.00%
	Commits de ambos integrantes	100.00%
		
## Funcionalidad		82.50%
	Apretar 'c' dice "Waiting for circle"	100.00%
	Hacer clicks luego hace círculos	100.00%
	Apretar 'r' dice "Waiting for rectangle"	100.00%
	Hacer clicks luego hace cuadrados	100.00%
	Apretar 'd' dice "Waiting for deletion"	100.00%
	Hacer clicks borra las figuras que corresponden	100.00%
	Apretar 's' dice "Waiting for 1st point of selection"	100.00%
	Hacer click dice "Waiting for 2nd point of selection"	100.00%
	Hacer click dice nada o algún texto indicando que se seleccionó	0.00%
	Hacer click de nuevo no rompe el flujo	100.00%
	Apretar otra tecla que las esperadas no rompe el flujo	0.00%
	El '+' hace crecer la selección	70.00%
	El '-' hace decrecer la selección, con una opción razonable cuando son muy chicas	70.00%
	Apretar 'e' sale de la aplicación	100.00%
		
## Modularización y diseño		92.50%
	Tienen un tipo para las figuras adecuado	100.00%
	TIenen un tipo para el estado razonable (lista de figuras, selección)	50.00%
	El flujo de la aplicación está bien diagramado	100.00%
	Usan bien funcional (no whiles, no refs, no raise)	100.00%
	Usan bien funciones de librería (sobre todo listas)	100.00%
		
## Calidad de código y tests		100.00%
	Sin estructuras redundantes	100.00%
	Indentación y estilo de código	100.00%
	Respetaron la estructura de directorios original	100.00%
	Pasan los tests	100.00%
	Testean suficientes casos	100.00%
## Opcionales		
	Puntos estrella	67.00%
	(Estrella) Las teclas numéricas dan color (1 N, 2 R, 3 A, 4 V)	100.00%
	(Estrella) Apretar 'a' inicia una nueva selección	0.00%
	Separaron en archivos y/o módulos	100.00%
# Nota Final		10.156
		
		
# Comentarios		
	Cuando se toca una tecla en vez de + o - la selección no se borra.	
	Queda el cartel "waiting for 2nd point of selection" luego de hacer el segundo click.	
	Si se toca una tecla incorrecta queda el mensaje (ej., "waiting for circle"), pero se pierde la funcionalidad (no se puede dibujar).	
	Las figuras no crecen centradas.	
	`if b then true else false` es equivalente a `b`.	
	Los aux_x1 y aux_y2 son feos en el lugar que están, y no hay forma de saber si están siendo utilizados.
