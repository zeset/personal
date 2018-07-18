# Corrección		
	Tag o commit corregido:	lab-2
		
## Entrega y git		100.00%
	Tag correcto	100.00%
	En tiempo	100.00%
	Commits frecuentes	100.00%
	Nombres de commits significativos	100.00%
	Commits de ambos integrantes	100.00%
## Funcionalidad		35.00%
	La aplicación arranca	100.00%
	Registro	50.00%
	Login de usuarios	50.00%
	Logout de usuarios	0.00%
	Crear un menú	0.00%
	Consultar el listado de pedidos realizados. Estados y saldos correctos. Como consumidor y como proveedor	0.00%
	Ver los pedidos pendientes y marcalos como finalizados.	0.00%
	Ingresar una dirección y obtener un listado de proveedores	100.00%
	Crear un pedido	0.00%
## Modularización y diseño		40.00%
	No fallo silencioso. (Alerts o logs en la consola)	100.00%
	Componentes distintos en módulos distinto	0.00%
	Diseño atómico	0.00%
	Manejo de estados: pocos componentes con estado	100.00%
	Manejo de estados: sólo el propio o de los hijos	100.00%
	Usaron JSX	100.00%
	Uso de proptypes adecuado	0.00%
	Diseño con containers y presentationals	0.00%
## Calidad de código		67.50%
	Sin estructuras redundantes	100.00%
	Líneas de más de 80 caracteres	50.00%
	Indentación y estilo de código	25.00%
	No subieron archivos json (además del locations.json)	100.00%
	Respetaron la estructura de directorios original	100.00%
## Opcionales		
	Puntos estrella	
		
		
# Nota Final		3.98
		
		
# Comentarios		
- El formulario de registro modifica los valores de consumidor y proveedor al mismo tiempo		
- No hay una redirección luego de registrarse o loguearse		
- No se indica en ningún lado cuando un usuario está registrado y no hay ningún link o botón para hacer logout		
- El logout no funciona siguiendo axios, sino que se hace un post y no se espera respuesta		
- El login es complicado, puesto que usa un componente que debería ser presentacional para hacer un cambio en el localStorage.		
- El componente "StoredLocally" no tiene sentido en absluto.		
- Al intentar agregar elementos al menú me lanza un error de bad request		
- El error anterior me impide probar gran parte de la funcionalidad de la aplicación		
- No se modularizó bien, específicamente no se hizo la diferencia entre container y presentational		
- No hacen correcto uso de proptypes		
- Hay muchos componentes que devuelven nulo, eso no tiene sentido		
- Hay un css metido entre los archivos de javascript		
- La indentación del HTML es muy engorrosa y hace difícil distinguir el código		
- Hay líneas de más de 80 caracteres		
