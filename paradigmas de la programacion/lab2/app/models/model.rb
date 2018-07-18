require 'json'
require_relative 'class_inherited_attributes'

# Abstract class with functions and attributes for all models
class Model
  # Class attributes
  include ClassInheritedAttributes
  # These are class instance variables shared across classes,
  # but that can be modified by the subclasses
  class_inherited_attributes :instances, :db_filename
  @instances = {}
  @db_filename = ''

  # This is a class attribute shared by all classes
  @@max_id = 1 # First free id

  # Instance attributes
  attr_reader :id

  def initialize
    @id = @@max_id
    @@max_id += 1
  end

  def self.from_hash(model_hash)
 
    model = self.new
    model_hash.each do |key, value|
      model.instance_variable_set("@#{key}", value)
    end
    # Check the global id is always the bigger one
    if model.id > @@max_id
      @@max_id = model.id + 1
    end
    model
  end

  def self.validate_hash(model_hash)
    # TODO complete this method also in the subclasses.
    # Read about the 'super' call.
  end

  # Returns a hash with all the attributes of the model.
  def to_hash
    hash = {}
    instance_variables.each do |attribute|
      hash[attribute.to_s.delete('@')] = instance_variable_get(attribute)
    end
    hash
  end

  # Saves the reference of the object in the self.class.instances and updates
  # the json files.
  def save
    if self.class.instances.key?(@id)
      raise KeyError, "Duplicate key (#{@id})"
    end
    # Save the object in our index
    self.class.instances[@id] = self
    # Save the object in the json file!
    self.class.save
  end

  # Saves the Model.instances attribute into a json file with name
  # Model.db_filename
  def self.save
    data_hash = []
    self.instances.each do |_, instance|
      data_hash.push(instance.to_hash)
    end
    file = File.open(self.db_filename, 'w')
    file.write(data_hash.to_json)
    file.close
  end

  # Returns all the saved instances of the class
  def self.all
    # ...
    self.instances
  end

  # Returns true if the object with the given id exists
  def self.index?(id)
    # ...
    self.instances.key?(id)
  end

  # Deletes the object with the given id
  def self.delete(id)
    # ...
    self.instances.delete(id)
  end

  # Returns an instance of the model with the given id, or
  # nil if no instance exists with such id.
  def self.find(id)
    if self.instances.key?(id)
      self.instances[id]
    end
    # The else return nil is implicit
  end

  # Function to return all instances with such attributes.
  # The parameter values is a hash from field_name to field_value
  def self.filter(values)
    r = []
    b = true
    self.instances.values.each do |instance|
      values.each do |field_name, field_value|
        if !(instance.instance_variable_get("@#{field_name}") == field_value) 
          b = false
        end  
      end    
      if b
        r << instance
      end
      b = true
    end
    r
  end

  # Function to check if an object with such attributes exists.
  # The parameter values is a hash from field_name to field_value
  def self.exists?(values)
    b = false
    self.instances.values.each do |instance|
      found_one = true
      values.each do |field_name, field_value|
        found_one = (instance.instance_variable_get("@#{field_name}") == field_value) && found_one
      end
      if found_one
        b = true
      end
    end
    b
  end

end