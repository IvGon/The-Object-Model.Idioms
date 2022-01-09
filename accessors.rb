module Accessors
  def self.included(base)
    base.extend ClassMethods
  end

  module ClassMethods
    def attr_accessor_with_history(*methods)
      methods.each do |method|
        # ---------------  attr_reader :method, :method_history -----------------------
        send(:attr_reader, method.to_sym, "#{method}_history".to_sym)
        
        # ---------------  attr_writer :method = value  -------------------------------
        define_method("#{method}=".to_sym) do |value|
          name_metod = "@#{method}".to_sym
          instance_variable_set(name_metod, value)

          history = "@#{method}_history".to_sym

          if instance_variable_defined?(history)
            instance_variable_get(history)
          else
            instance_variable_set(history, [])
          end  

          instance_variable_get(history).push(instance_variable_get(name_metod))
        end
      end
    end

    # ----------- type - class or module required!!! ----------------------------
    
    def strong_attr_accessor(method, type)
      # type.capitalize!
      name_metod = "@#{method}".to_sym
      # ---------------  attr_reader :method ------------------------------------
      send(:attr_reader, method.to_sym)

      # ---------------  attr_reader :method_-------------------------------------
      define_method("#{method}=".to_sym) do |value|
         raise TypeError.new('Invalid type of visible value!') unless value.is_a?(type) 
         instance_variable_set(name_metod, value)
      end
      rescue TypeError => e
        puts e
        retry
    end

  end
end
