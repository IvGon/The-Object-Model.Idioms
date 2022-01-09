module Validation

  def valid?
    raise 'ValidationErrors' unless  validate!
    true
  rescue StandardError
    false
  end

  def validate!
    valid_class = Object.const_get("#{self.class.name}Validator")
    @validator = valid_class.new(self)
    @validator.obj_valid?
  end


  def valid_errors
    return {} unless defined?(@validator)
    @validator.errors
  end
end

class ValidationErrors
  attr_accessor :messages

  def initialize
    @messages = {}
  end

  def add(name, msg)
    (@messages[name] ||= []) << msg
  end
end

module Validate
  def self.included(base)
    base.extend ClassMethods
    base.send :include, InstanceMethods
  end

  module InstanceMethods
    attr_reader :object, :errors

    def initialize(object)
      @object = object
      @errors = ValidationErrors.new
    end

    def obj_valid?
      self.class.validators.each { |condition| validate(condition) }
      @errors.messages.empty?
    end


    private

    def validate(args)
      action = args[1]
      if action.key?(:empty)
        empty_validator(*args)

      elsif action.key?(:type)
        type_validator(*args)

      elsif action.key?(:option)
        option_validator(*args)
      end
    end

    def empty_validator(attribute, condition)
      raise unless condition[:empty].call(@object)
    rescue StandardError
      @errors.add(attribute, condition[:msg])
    end

    def option_validator(attribute, condition)
      raise unless condition[:option].call(@object)
    rescue StandardError
      @errors.add(attribute, condition[:msg])
    end

    def type_validator(attribute, condition)
      raise unless @object.send(attribute).is_a?(condition[:type])
    rescue StandardError  
      @errors.add(attribute, "it should be #{condition[:type].attribute}")
    end
  end

  module ClassMethods
    def validates(*condition)
      create_validation(condition)
    end

    def validators
      @validators
    end

    private

    def create_validation(condition)
      @validators = [] unless defined?(@validators)
      @validators << condition
    end
  end
end
