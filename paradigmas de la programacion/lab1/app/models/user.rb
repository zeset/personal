require_relative 'model'

class User < Model
	attr_accessor :email, :password, :location, :balance

  @db_filename = 'db_user'

	def initialize
		super
	end

	def self.validate_hash(model_hash)
		super && model_hash.key?(:email) && model_hash.key?(:password) && model_hash.key?(:location) && model_hash.key?(:balance)
  end
end

class Consumer < User

  @db_filename = 'db_consumer'

  ## (mteruel) no es necesario sobreescribir el metodo si va a realizar las
  ## acciones mismas
  def initialize
    super
  end
end

class Provider < User
  attr_accessor :store_name, :max_delivery_distance

  @db_filename = 'db_provider'

  def initialize
    super
  end

  def self.validate_hash(model_hash)
    super && model_hash.key?(:store_name) && model_hash.key?(:max_delivery_distance)
  end
end
