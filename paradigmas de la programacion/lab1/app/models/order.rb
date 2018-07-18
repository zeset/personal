require_relative 'model'	

class Order < Model
	attr_accessor :status, :items, :order_amount, :provider, :consumer, :provider_name, :consumer_email, :consumer_location
	@db_filename = 'db_order'

	def initialize
		super
	end

	def self.validate_hash(model_hash)
		super && model_hash.key?(:status) && model_hash.key?(:items) && model_hash.key?(:order_amount) && model_hash.key?(:provider) && model_hash.key?(:consumer) && model_hash.key?(:provider_name) && model_hash.key?(:consumer_email) && model_hash.key?(:consumer_location)
	end
end