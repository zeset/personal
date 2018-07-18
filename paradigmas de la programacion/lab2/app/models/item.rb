require_relative 'model'

class Item < Model
	attr_accessor :name, :price, :provider
  	@db_filename = 'db_item'

	def initialize
		super
	end

	def self.validate_hash(model_hash)
		super && model_hash.key?(:description) && model_hash.key?(:price) && model_hash.key?(:provider)
	end
end