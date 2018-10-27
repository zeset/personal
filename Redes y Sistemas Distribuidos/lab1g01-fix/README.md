## Informe de Laboratorio 1 ##
Redes y Sistemas Distribuidos
Nahuel Borda, Luigi de Carlini y Paula Reyna

En este laboratorio nos fue asignada la tarea de implementar un servidor de archivos en Python 2,
que soportase completamente el protocolo de transferencia de archivos HFTP(Home-made File Transfer Protocol), el cual
usa TCP como protocolo de transporte.
Primeramente cabia entender como funcionaban este tipo de servidores. Cuando un cliente HFTP inicia el intercambio de
mensajes mediante pedidos o comandos ​al servidor, este envia una respuesta ​a cada uno antes de procesar el siguiente.
Esto continua hasta que el cliente manda un comando de fin de conexion. En caso de que el cliente envíe varios pedidos
consecutivos, el servidor HFTP los responde en el orden en que se enviaron.

## SERVER SOCKET ##
Siguiendo esta logica, se implemento un socket servidor en el archivo server.py, el cual constituye el mecanismo para la
entrega de paquetes de datos provenientes de la tarjeta de red a los procesos o hilos apropiados. Queda asi definido por la
direccion y el puerto con los cuales nos interesa que se establezca una conexion(en este caso, la address de nuestro host
local ya que solo nos interesa que sea accesible desde nuestra maquina, y el puerto TCP 19500, usado por HFTP). Luego
utilizando la funcion socket.listen() provista por la libreria de manejo de sockets, le especificamos al socket la cantidad
de peticiones de conexion maximas que pueden encolarse antes de rechazar conexiones externas. En este caso usamos el 1, ya
que nuestro servidor no es multicliente.

    def __init__(self, addr=DEFAULT_ADDR, port=DEFAULT_PORT,
                 directory=DEFAULT_DIR):
        print "Serving %s on %s:%s." % (directory, addr, port)
        self.directory = directory
        self.serversocket = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
        self.serversocket.setsockopt(socket.SOL_SOCKET, socket.SO_REUSEADDR, 1)
        self.serversocket.bind((addr,port))
        self.serversocket.listen(1)
		
		
Luego, en el loop principal del servidor, implementamos la aceptacion de un socket cliente, el cual podra pedirle archivos al 
servidor que acabamos de especificar. Se llama al argumento Connection(), el cual sera analizado en detalle mas adelante.
Finalmente, el argumento handle() checkea todos los request que llegan al servidor y los divide en comandos y argumentos,
para luego comenzar su ejecución. Al finalizar el loop, el cliente se desconecta.

	while True:
            (clientsocket, address) = self.serversocket.accept()
            conn = connection.Connection(clientsocket,self.directory)
            conn.handle()


## CONEXIONES Y SU MANEJO ## 
Analizaremos ahora lo implementado en el archivo connection.py. 
Primeramente, tenemos la implementacion de connection(),mencionada anteriormente. Esta tiene como objetivo satisfacer los
pedidos del cliente hasta que termina la conexión. 
Para ello, primero planteamos inicializar los parametros necesarios para establecer una conexion. Dentro del listado de estos
parametros, tenemos la asignacion a un client_socket, al cual le devolveremos las respuestas y del cual tomaremos pedidos,
tenemos un directorio de archivos de los cuales extraeremos la data necesaria para completar el pedido de un cliente, y
tenemos una variable de estado actual del servidor, setteada por default en 0. Decidimos tambien implementar otras variables
como response(encargado de trasmitir los outputs para el cliente), el error_count(lleva registro de los errores), varios
booleano como connected (determina si el cliente esta conectado o no), force_send(fuerza en situaciones especificas el envio
de una respuesta) y client_is_here(leva registro de si un cliente esta activo o no). Hemos implementado los parametros wish,
donde se especifica que requiere el cliente del servidor, arguments donde se especifica los datos a devolver al servidor, y
data,cuya forma es (wish,arguments).
		
		def __init__(self, socket, directory):
        			self.client_socket = socket
        			self.directory = directory
        			self.current_state = CODE_OK
        			self.connected = True
        			self.client_is_here = True

Luego pasamos a definir la funcion error_notify ,la cual es la encargada de notificar al servidor de los errores de
funcionamiento o con la interaccion con el cliente. Siempre y cuando el cliente este activo, y el error no sea fatal, error_notify
se encargara de pasarle al respond y continua ejecutando. Caso contrario, devuelve una respuesta y lanza un quit.
 
 	if self.client_is_here and not fatal_status(self.current_state):
          .
		  .
		  .
		  self.respond("")
 	elif self.client_is_here: 
            -
			-
			self.respond("")
            self.quit()

Pasamos ahora a la implementacion de respond(). Esta es la funcion nuclear encargada del manejo de las respuestas al cliente.
Empieza asignandole a la response los argumentos del input, para luego intentar mandar los mensajes al cliente. Luego se
cambia el status del mensaje a enviado. En caso de que haya un error de transmision especificado en la libreria de sockets,
se le asigna al estado un error y se llama a error_notify, mencionada anteriormente.
		
		except socket.error:
            self.current_state = INTERNAL_ERROR
            self.error_notify()

Tenemos luego definidas las funciones check_int, check eol,check_valid_char y quit. Check_int se asegura de que el input dado sea un int en 
forma de string. Por su parte, quit especifica si la sesion de un cliente caduco.Check_eol, por su parte, determina si
los \r y los \n estan bien ubicados dentro de los EOL. Finalmente, check_valid_char asegura que los caracteres enviados por el cliente sean correctos.
Caso contrario, devuelve un BAD_REQUEST

La funcion siguiente es react(), la cual es la encargada del manejo de los pedidos y de su determinada ejecucion. Es tambien
la encargada de notificar errores, como si un pedido esta mal formado, si sus argumentos son invalidos, o si el comando
recibido no es un metodo valido. Esta funcion primariamente clasifica los "wishes" o deseos del cliente, dando luego el
metodo a ejecutar. Por ejemplo, si el wish del cliente es "get_metadata", en caso de haber obtenido del cliente un input
valido(data), se llamara a la funcion get_metadata(data). Caso contrario, se le avisa al cliente que su pedido no pudo ser
concretado, y se llama a la funcion error_notify.
		
		if wish == "get_file_listing":
		.
		.
		.
		self.get_file_listing()
		elif wish == "get_metadata":
            if (len(data) != 1):
                self.current_state = BAD_REQUEST
                self.error_notify()
            else:
                self.get_metadata(data)
				
Veremos ahora las funciones que pueden llamar el cliente a traves de la consola. Ademas de quit , hemos definido
otras 3. La primera, get_file_listing, cuya utilidad es la de devolverle al cliente el listado de archivos en el directorio
actual.Esto se hace ciclicamente devolviendo como una respuesta los archivos del directorio. Esta funcion devuelve un error 
si se encuentra alguna excepcion de las especificadas por la libreria de errores OS. 
			
			.
			.
			for file in files:
                response = response + file + EOL
			.
			.
			
En segundo lugar, tenemos get_metadata, que devuelve el tamaño del archivo ingresado en bytes. Notificará de un error si no existe el archivo del pedido,si ocurre un 
error de tipo en el argumento (relatado en respond()), si el archivo no esta en el directorio o si ocurre un error al listar los archivos.
	
	if file in files:
		self.respond(str(os.path.getsize(
                             os.path.join(self.directory, file))) + EOL)
	.
	.
	.
		except OSError:
                    self.current_state = INTERNAL_ERROR
                    self.error_notify()
            else:
                self.current_state = FILE_NOT_FOUND
                self.error_notify()
        except OSError:
            self.current_state = INTERNAL_ERROR
            self.error_notify()

Finalmente, tenemos la funcion get_slice, la cual devuelve al cliente una porcion de un archivo desde un punto
determinado dado por un offset, del tamaño dado por el cliente. 

	while size and \
           (self.connected):
                   if BUFFER > size:
                       file_slice = file.read(size)
                       size = 0
					else:	
					   file_slice = file.read(BUFFER)
       					size -= BUFFER
				file_slice = str(len(file_slice)) + " " + \
                                                 file_slice

                   if self.connected:
                       self.respond(file_slice + EOL)

	
Esta notificará de un error si
    a) no existe el archivo del pedido
    b) ocurre un error de tipo en el argumento (relatado en respond() y aqui)
    c) ocurre un error al abrir (open()) el archivo
    d) el archivo no esta en el directorio
    e) no se cumple offset≤filesize<offset+size
Cabe notar que esta funcion tiene acceso a la ejecución de otras funciones como respond(), algo que no tienen otros metodos 
a los cuales tenga acceso el cliente. Esto ha sido implementado asi debido a que aqui son necesarias respuestas dinamicas al
cliente.
Finalmente dentro de este archivo tenemos la funcion handle,la cual constituye el loop principal del servidor. Es iniciado al 
comenzar una sesión y caduca al aparecer errores fatales, ejecutar un quit, o cuando ocurre una desconexion apresurada del 
cliente. Es aqui donde se checkean todos los request que llegan al servidor y se dividen en comandos y argumentos, para luego 
comenzar su ejecución. Esto funciona como el gestor del canal de comunacion cliente-servidor, siempre y cuando el cliente 
este conectado y activo en su sesion.
  		
		while self.connected and self.client_is_here:
            if not remaining:
                self.partial_request = self.client_socket.recv(BUFFER)
                socket_buffer = socket_buffer + self.partial_request
		    if not socket_buffer:
                self.quit()

Al cerrarse el ciclo se desconecta el cliente.
		
		.
		.
		.	
        self.client_socket.close()

## OTROS ARCHIVOS ##
Se ha modicado ademas de server.py y connection.py, el archivo constants.py. Se han agregado algunas constantes como buffer,
la cual es usada por handle para definir el espacio maximo de los buffer de pedidos,o como blank para definir un espacio. En
este archivo se encuentran listados los errores posibles dentro de las ejecuciones.

	.
	.
	BUFFER = 4096

	BLANK = ' '

	CODE_OK = 0
	BAD_EOL = 100
	BAD_REQUEST = 101
	INTERNAL_ERROR = 199
	INVALID_COMMAND = 200
	INVALID_ARGUMENTS = 201
	FILE_NOT_FOUND = 202
	BAD_OFFSET = 203
	.
	.

## PREGUNTA DEL LABORATORIO ##
Si bien nuestro servidor implementado no es multicliente, podemos ver que lo que este podria necesitar para serlo conlleva 
muchas modificaciones. Entendemos que dentro de server.py deberia haber ya en la creacion del socket servidor, una 
modificacion en socket.listen donde el input deberia ser un entero mayor a uno. Deberiamos tambien atender la concurrencia 
entre los clientes, sus pedidos y sus respuestas, ya que como fue aclarado anteriormente, nuestro protocolo atiende los 
pedidos de manera FIFO. 
Sin embargo, existe una soluccion denominada polling, el cual permite el monitoreo de muultiples conexiones
usando un solo thread, y recibir notificaciones cuando cualquiera de ellos tiene datos disponibles. 
poll() es una system call soportada por la mayoria de los sistemas Unix, y permite una mayor escalabilidad.



