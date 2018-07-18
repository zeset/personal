# Corrección		
	Tag o commit corregido:	rec-lab-2
		
## Entrega y git		96.00%
	Tag correcto	100.00%
	En tiempo	100.00%
	Commits frecuentes	90.00%
	Nombres de commits significativos	80.00%
	Commits de ambos integrantes	100.00%
## Funcionalidad		97.00%
	La aplicación arranca	100.00%
	Registro	100.00%
	Login de usuarios	100.00%
	Logout de usuarios	85.00%
	Crear un menú	85.00%
	Consultar el listado de pedidos realizados. Estados y saldos correctos. Como consumidor y como proveedor	100.00%
	Ver los pedidos pendientes y marcalos como finalizados.	100.00%
	Ingresar una dirección y obtener un listado de proveedores	100.00%
	Crear un pedido	100.00%
## Modularización y diseño		100.00%
	No fallo silencioso. (Alerts o logs en la consola)	100.00%
	Componentes distintos en módulos distinto	100.00%
	Diseño atómico	100.00%
	Manejo de estados: pocos componentes con estado	100.00%
	Manejo de estados: sólo el propio o de los hijos	100.00%
	Usaron JSX	100.00%
	Uso de proptypes adecuado	100.00%
	Diseño con containers y presentationals	100.00%
## Calidad de código		93.00%
	Sin estructuras redundantes	80.00%
	Líneas de más de 80 caracteres	100.00%
	Indentación y estilo de código	90.00%
	No subieron archivos json (además del locations.json)	100.00%
	Respetaron la estructura de directorios original	100.00%
## Opcionales		
	Puntos estrella	75.00%
		
		
# Nota Final		9.4
		
		
# Comentarios		
- Los commits estuvieron todos sobre la hora y los mensajes no son demasiado
  significativos		
- El logout debería lanzar una pantalla de "loading" mientras se resuelve el
  `axios.post`. Y no debería devolver nulo.		
- Al crear el menú la primera vez que intento crear o borrar un elemento no hay
  actualización inmediata y si se intenta crear el item de vuelta recién ahi
  comienza a funcionar normal.		
- Ojo al espaciar. Especial atención en que no queden declaraciones de métodos
  de una clase sin espacios en el medio, porque hace difícil saber donde
  termina un método y comienza el otro.		
- Se esperaba que hicieran uso del método `axios.interceptor` para evitar tener
  que declarar las redirecciones manualmente en cada componente. Más aún, de la
  forma que lo hicieron se esperaría que extrapolaran el método a una función
  independiente que llamaran en lugar de escribir el mismo código varias veces.		
