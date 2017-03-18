module Accessors
  # getter, setter
  # history of setter
  def attr_accessor_with_history(*names)
    names.each do |name|
      # create_getter
      varname = "@#{name}".to_sym
      define_method(name.to_sym) { instance_variable_get(varname) }

      # create_history_getter
      hist_var  = "@#{name}_history".to_sym
      define_method("#{name}_history".to_sym) { instance_variable_get(hist_var) }

      # create_history_setter
      define_method("#{name}=".to_sym) do |value|
        if instance_variable_defined?(hist_var)
          history = instance_variable_get(hist_var)
          instance_variable_set(hist_var, history << value)
        else
          instance_variable_set(hist_var, [value])
        end
        instance_variable_set(varname, value)
      end
    end # names.each do
  end

  # input: foo: String, bar: Integer, baz: Array
  def strong_attr_accessor(hash)
    hash.each do |name, klass|
      # create_getter
      define_method(name.to_sym) { instance_variable_get("@#{name}".to_sym) }

      # create_setter
      var  = "@#{name}".to_sym
      meth = "#{name}=".to_sym
      define_method(meth) do |value|
        raise ArgumentError, 'Wrong argument class' unless value.is_a?(klass)
        instance_variable_set(var, value)
      end
    end
  end
end
