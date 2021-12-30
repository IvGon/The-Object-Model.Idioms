module Validation
  def obj_valid?
    valid_class = Object.const_get("#{self.class.name}Validator")
    @validator = valid_class.new(self)
    @validator.valid?
  end

  def attr_validate(*args)
    obj_valid? unless defined?(@validator)
    validate(@validator.class.validators.find { |item| item[0] == args[0] })
    @errors.messages.empty?
  end

  def errors
    return @validator.errors.messages if defined?(@validator)
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

    def valid?
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
      return if @object.send(attribute).is_a?(condition[:type])
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
