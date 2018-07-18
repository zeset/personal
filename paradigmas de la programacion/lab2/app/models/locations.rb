require_relative 'model'

class Location < Model
	attr_accessor :name
	@db_filename = "db_locations"

	def initialize
		super
	end

	def self.validate_hash(model_hash)
		super && model_hash.key?(:name)
	end
end