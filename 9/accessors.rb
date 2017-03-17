module Accessors
  # getter, setter
  # history of setter
  def attr_accessor_with_history(*names)
    names.each do |name|
      create_getter(name)
      create_history_getter(name)
      create_history_setter(name)
    end
  end

  # input: foo: String, bar: Integer, baz: Array
  def strong_attr_accessor(hash)
    hash.each do |name, klass|
      create_getter(name)
      create_setter(name) do |value|
        raise ArgumentError, 'Wrong argument class' unless value.is_a?(klass)
      end
    end
  end

  protected

  def create_getter(name)
    define_method(name.to_sym) { instance_variable_get("@#{name}".to_sym) }
  end

  def create_setter(name)
    var  = "@#{name}".to_sym
    meth = "#{name}=".to_sym
    define_method(meth) do |value|
      yield if block_given?
      instance_variable_set(var, value)
    end
  end

  def create_history_setter(name)
    hist_var = "@#{name}_history".to_sym

    define_method("#{name}=".to_sym) do |value|
      if instance_variable_defined?(hist_var)
        history = instance_variable_get(hist_var)
        instance_variable_set(hist_var, history << value)
      else
        instance_variable_set(hist_var, [value])
      end

      instance_variable_set("@#{name}".to_sym, value)
    end
  end

  def create_history_getter(name)
    hist_varname  = "@#{name}_history".to_sym
    hist_methname = "#{name}_history".to_sym
    define_method(hist_methname) { instance_variable_get(hist_varname) }
  end
end
