require 'json'
require 'sinatra/base'
require 'sinatra/json'
require 'sinatra/namespace'
require_relative './models/item'
require_relative './models/order'
require_relative './models/locations'
require_relative './models/user'

# Main class of the application
class DeliveruApp < Sinatra::Application
  register Sinatra::Namespace

  enable :sessions unless test?

  ## Function to clean up the json requests.
  before do
    begin
      if request.body.read(1)
        request.body.rewind
        @request_payload = JSON.parse(request.body.read, symbolize_names: true)
      end
    rescue JSON::ParserError
      request.body.rewind
      puts "The body #{request.body.read} was not JSON"
    end
  end

  register do
    def auth
      condition do
        halt 401 unless session.key?(:logged_id) || self.settings.test?
      end
    end
  end

  ## API functions
  namespace '/api' do
    # TODO program API get and post calls.
    # ...
    post '/login' do
      # Aqui es donde se hace el login de los usuarios de la API. Notifica un error si el email ingresado no corresponde con
      # ningun email guardado en las bases de datos(error 401), o si la contraseña no corresponde con lo guardado en la db(error 403)
      email = @request_payload[:email]
      password = @request_payload[:password]
      if Consumer.exists?(email: email, password: password)
        user = Consumer.filter(email: email, password: password)[0]
      elsif Provider.exists?(email: email, password: password)
        user = Provider.filter(email: email, password: password)[0]
      else
        halt 401, 'Usuario inexistente'
      end
      if !(password == user.password)
        halt 403, 'Acceso Denegado'
      end
      #Aqui se le asigna la id correspondiente al usuario loggeado actualmente
      session[:logged_id] = user.id
      #Aqui se retorna finalmente el codigo de que todo el proceso fue correcto(200), y datos del usuario correspondiente, en forma de json
      ## (mteruel) no es necesario devolver el 200.
      [200, { id: user.id, isProvider: Provider.exists?(email: email, password: password) }.to_json]

    end

    post '/logout' do
       # Aqui cierra la sesion del usuario actualmente activo
      session.clear
      redirect '/'
    end

    post '/consumers' do
      #Aqui se hace el registro de los consumers. Notifica un error si no recibio una id valida(error 400), o si el email ingresado
      #pertenece a un usuario ya registrado, ya sea un consumer o un provider(error 409)
      email = @request_payload[:email]
      password = @request_payload[:password]
      location = @request_payload[:location]
      if email.nil? || location.nil? || password.nil?
        halt 400
      end
      if Consumer.exists?(email: email) || Provider.exists?(email: email)
        halt 409
      end
      #Aqui construimos el hash que contiene dentro la informacion del consumer necesaria para mandarla por un json
      #Posteriormente ese usuario se guarda a traves de save en la db
      user = Consumer.from_hash({email: email, location: location, password: password, balance: 0})
      user.save
      # Esta es la respuesta que devuelve el metodo en caso de que todo haya salido bien(codigo 200, y la id del consumer nuevo)
      [200, user.id.to_s]
    end

    post '/providers' do
      #Aqui se hace analogamente el registro de los providers. Se piden mas datos al request payload debido a que necesitamos el
      #nombre de la tienda del provider, y su distancia maxima de delivery.Al igual que post/consumers, notifica un error si
      #no recibio una id valida(error 400), o si el email ingresado pertenece a un usuario ya registrado,
      #ya sea un consumer o un provider, agregando el caso de si ya existe una tienda con el nombre ingresado
      email = @request_payload[:email]
      store_name = @request_payload[:store_name]
      location = @request_payload[:location]
      password = @request_payload[:password]
      max_delivery_distance = @request_payload[:max_delivery_distance]
      if Consumer.exists?(email: email) ||
         Provider.exists?(email: email) ||
         Provider.exists?(store_name: store_name)
        halt 409
      end
      if email.nil? || location.nil? || password.nil? || store_name.nil? ||
         max_delivery_distance.nil?
        halt 400
      end
      #Aqui se crea el hash de informacion del provider con todos los datos extraidos de los request_payload
      user = Provider.from_hash({email: email,
                                  store_name: store_name,
                                  location: location,
                                  password: password,
                                  max_delivery_distance: max_delivery_distance,
                                  balance: 0
                                  })
      #Igual que en post/consumers, se guarda el provider nuevo en la db, y se retorna la respuesta como
      #[codigo 200, id del provider nuevo]
      user.save
      [200, user.instance_variable_get('@id').to_s]
    end


    get '/consumers', :auth => nil  do
      #Aqui se recuperan todos los consumers registrados en la db
      json_response = []
      #Agregamos los valores que nos interesan en una respuesta en forma de json, para luego devolverlo en forma
      #[codigo 200, respuesta en forma json]
      Consumer.all.values.each do |instance|
        info = {id:instance.id,
                email:instance.email,
                location:instance.location}
        json_response << info
      end
      [200, json_response.to_json]
    end

    get '/locations' do
      #Aqui se recuperan todas las locations en la db
      r = []
      #Analogamente a get/consumers aqui guardamos los valores que nos interesan en una respuesta, que luego es enviada
      #en forma de json con el codigo 200
      Location.all.values.each do |instance|
        r << instance.to_hash
      end
      [200, r.to_json]
    end

    get '/providers', :auth => nil  do
      #Aqui extraemos la id de la location. En caso de que esta sea nula, devolvemos todos los providers
      # guardandolos en una respuesta que luego es enviada en forma de json con el codigo 200
      r = []
      lid = params[:location]
      if lid.nil?
        Provider.all.values.each do |prov|
          r << prov.to_hash
        end
      else
      #En el caso contrario, encontramos los providers que se encuentran en esa location dada y los devolvemos empaquetados en un json
      #dentro de la variable r, junto con el codigo 200. Si la location no esta la db, notifica un error 404
        lid = Integer(lid)
        if !(Location.index?(lid))
          halt 404
        end
        Provider.filter({location: lid}).each do |instances|
          r << { id: instances.id,
                 email: instances.email,
                 location: instances.location,
                 store_name: instances.store_name
                }
        end
      end
      [200, r.to_json]
    end

    get '/users/:id' , :auth => nil do
    	#Chequea que el id no sea nil . Si no lo es, lo castea
    	#Lo busca en consumers y providers, si es alguno de los dos, devuelve el email y el balance de ese usuario
    	# Notifica un error 400 si la id dada es nula. Si la id no corresponde a un consumer o a un provider, devuelve 404
      if params[:id].nil?
        halt 400
      end
      id = params[:id].to_i
      if !(Provider.index?(id)) && !(Consumer.index?(id))
        halt 404
      end
      if Provider.index?(id)
        usr = Provider.find(id)
      else
        usr = Consumer.find(id)
      end
      [200, { email: usr.email, balance: usr.balance }.to_json]
    end

    post '/items' , :auth => nil do
      #Aqui es donde se cargan items a un menu.Se obtienen primeramente datos que nos interesan a traves del request_payload
      #Notifica un error si el nombre, el precio o el provider dado son nulos(error 400), en el caso de que no exista la id
      #de un provider(error 404), o en caso de estar agregando un item que ya existe en la db(esto evita items duplicados)
      name = @request_payload[:name]
      price = @request_payload[:price]
      provider = @request_payload[:provider]
      if name.nil? || price.nil? || provider.nil?
        halt 400
      elsif !(Provider.index?(provider))
        halt 404
      elsif Item.exists?({provider: provider, name: name})
        halt 409
      else
        #Aqui creamos el hash donde devolvemos datos que nos interesen del item. Posteriormente se guarda en la db a traves de save
        item = Item.from_hash({name: name, price: price, provider: provider})
        item.save
        #Se devuelve [200, id del item nuevo]
        [200, item.id.to_json]
      end
    end

    post '/items/delete/:id' , :auth => nil do
      #Aqui es donde se borran items del menu de un provider.Notifica un error si el item a borrar no
      #pertenece al provider conectado actualmente que esta intentando borrarlo(error 403),o si el item a borrar no existe(error 404)
      id = params[:id].to_i
      if !(Item.index?(id))
        halt 404
      end
      if session[:logged_id] && (Item.find(id).provider != session[:logged_id])
        halt 403
      end
      #En caso de que se hayan pasado las verificaciones anteriores, se pasa a borrar a traves del procedimiento delete al item seleccionado
      Item.delete(id)
      #Se guarda lo hecho. Se devuelve un 200 en caso de exito.
      Item.save
      200
    end

    get '/items' , :auth => nil do
      #Aqui se recuperan los items en la db. Se pide la id del provider y se la castea como un entero.
      #Si la id dada no corresponde con ningun provider que exista, se notifica un error 404.
      #En caso de que la id sea nula, se devuelven todos los items en la db
      items = []
      id = params[:provider]
      if id.nil?
        Item.all.values.each do |instance|
          items << instance.to_hash
        end
      else
        id = id.to_i
        if !(Provider.index?(id))
          halt 404
        else
          #Una vez pasadas las verificaciones anteriores pedimos todos los items del proveedor elegido, y guardamos todos los hash de items
          #en un arreglo
          Item.filter(provider: id).each do |instance|
            items << instance.to_hash
          end
        end
      end
      #Finalmente se devuelve la respuesta como [200, items en formato json]
      [200, items.to_json]
    end

    post '/orders' , :auth => nil do
      #Aqui se crea una orden nueva. Primeramente, se piden los datos que nos interesan a traves de request payload.
      #Notifica un error si alguno de los campos obtenidos es nulo(codigo 400), o si el consumer o el provider no existen
      #en la db(error 404)

      provider = @request_payload[:provider]
      items = @request_payload[:items]
      consumer = @request_payload[:consumer]

      if (provider.nil? || items.empty? || consumer.nil?)
        halt 400
      end
      do_they_all_exist = true
      items.each do |item|
        do_they_all_exist  = do_they_all_exist && Item.exists?({id: item[:id].to_i})
      end
      if !(Provider.index?(provider)) || !(Consumer.index?(consumer)) || !(do_they_all_exist)
        halt 404
      end
      #Si se pasa esta tanda de verificaiones y el item existen, se calcula el precio de la orden, dada por el precio de
      #cada item multiplicado por la cantidad de items ordenados. Esto se guarda en price
      price = 0
      items.each do |item|
        id = item[:id]
        amount = item[:amount]
        price += Item.find(id).price*amount
      end
      #Aqui se arma el hash de la orden, con todos los datos obtenidos anteriormente. Posteriormente se guarda
      order = Order.from_hash({status: 'payed',
                              items: items,
                              order_amount: price,
                              provider: provider,
                              consumer: consumer,
                              provider_name: Provider.find(provider).store_name,
                              consumer_email: Consumer.find(consumer).email,
                              consumer_location: Consumer.find(consumer).location
                              })
      order.save
      #Aqui calculamos los balances de los usuarios que intervienen en la orden creada. Se suma y resta a los balances segun corresponda
      # y luego se guarda a los usuarios con sus balances actualizados
      balance_p = Provider.find(provider).instance_variable_get('@balance')
      Provider.find(provider).instance_variable_set('@balance', balance_p + price)
      balance_c = Consumer.find(consumer).instance_variable_get('@balance')
      Consumer.find(consumer).instance_variable_set('@balance', balance_c - price)
      Provider.save
      Consumer.save
      #Aqui se da la respuesta[200, id de la orden]
      [200, order.id.to_s]
    end

    get '/orders' , :auth => nil do
     #Aqui es donde se obtienen las ordenes. Notifica un error si el parametro recuperado es nulo(error 400), o si la id recuperada no
     #corresponde a un usuario, sea un consumer o un provider(error 404)
      user_id = params[:user_id]
      if user_id.nil?
        halt 400
      end
      user_id = user_id.to_i
      consumer = Consumer.index?(user_id)
      provider = Provider.index?(user_id)
      if !(consumer || provider)
        halt 404
      end
      # Aqui se especifica que hacer si el usuario es un consumidor.
      # Se filtran las ordenes por las especificas de ese consumer, y se las guarda en un arreglo r
      if consumer
        r = []
        Order.filter(consumer: user_id).each do |instance|
          r << instance.to_hash
        end
      else
        #Procedimiento analogo si el usuario es un provider
        r = []
        Order.filter(provider: user_id).each do |instance|
          r << instance.to_hash
        end
      end
      #Se devuelve como respuesta el arreglo r obtenido en forma de json y el codigo 200 en caso de exito
      [200, r.to_json]
    end

    get '/orders/detail/:id' , :auth => nil do
      #Aqui se obtienen los detalles de una orden. Notifica error si el id obtenido es nula(400), o el id no se corresponde
      #con ninguna orden en la db
      id = params[:id]
      if id.nil?
        halt 400
      end
      id = id.to_i
      if !Order.index?(id)
        halt 404
      end
      # Si se pasan estas verificaciones se procede a encontrar la orden correspondiente, y se guardan los datos que nos interesan en
      # un arreglo r
      r = []
      Order.find(id).instance_variable_get('@items').each do |item|
        r << {id: item[:id],
              name: Item.find(item[:id]).name,
              price: Item.find(item[:id]).price,
              amount: item[:amount]
              }
      end
      #Se devuelve como respuesta el arreglo r obtenido en forma de json y el codigo 200 en caso de exito
      [200, r.to_json]

    end

    post '/deliver/:id' , :auth => nil do
      #Aqui se especifica el estado de una orden. Recibe un parametro id, que se castea a entero
      # Notifica un error si la id dada no corresponde con ninguna orden en la db
      order_id = params[:id].to_i
      if !Order.index?(order_id)
        halt 404
      end
      # Si se pasa esta verificacion entonces se cambia el status de la orden a entregado. Finalmente se guarda la orden con
      #su nuevo estado y se devuelve 200 en caso de exito
      Order.find(order_id).status = 'delivered'
      Order.save
      200
    end

    post '/orders/delete/:id' , :auth => nil do
      #Aqui se borran ordenes.Se obtiene una id que se castea a entero
      id = params[:id].to_i
      # Luego se procede a borrar la orden con la id dada, y se guarda lo hecho
      Order.delete(id)
      Order.save
      200
    end

    post '/users/delete/:id' , :auth => nil do
      #Aqui se borran usuarios. Se obtiene una id que se castea a entero
      id = params[:id]
      id = id.to_i
      #Si la id pertenece a un consumer, se borra ese usuario y se guarda lo hecho. Ocurre lo analogo si la id coincide con un provider
      if Consumer.index?(id)
        Consumer.delete(id)
        Consumer.save
      elsif Provider.index?(id)
        Provider.delete(id)
        Provider.save
      else
        #En caso de que la id no pertezca a ningun usuario, se notifica un error 404
        halt 404
      end
      # En caso de exito se devuelve 200
      200
    end

    get '*' do
      halt 404
    end
  end

  # This goes last as it is a catch all to redirect to the React Router
  get '/*' do
    erb :index
  end
end
