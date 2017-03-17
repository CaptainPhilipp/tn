module Accessors
  attr_accessor :access_history

  # getter, setter
  # history of setter
  def attr_accessor_with_history(*names)
    @access_history = {}
    names.each do |name|
      create_getter(name)
      create_history(name)
      create_history_setter(name)
    end
  end

  # input: foo: String, bar: Integer, baz: Array
  def strong_attr_accessor(hash)
    hash.each do |name, klass|
      create_getter(name)
      klass = klass.is_a?(Class) ? klass : const_get(klass.to_sym)
      create_setter(name) do |value|
        raise ArgumentError, 'Wrong argument class' unless value.is_a?(klass)
      end
    end
  end

  protected

  def create_getter(name)
    define_method(name.to_sym) { instance_variable_get("@#{name}".to_sym) }
  end

  # может служить оберткой для расширения сеттеров
  def create_setter(name)
    varname  = "@#{name}".to_sym
    methname = "#{name}=".to_sym
    define_method(methname) do |value|
      yield(value) if block_given?
      instance_variable_set(varname, value)
    end
  end

  # расширенный setter
  def create_history_setter(name)
    create_setter(name) { |value| self.access_history[name] << value }
  end

  def create_history(name)
    varname  = "@#{name}_history".to_sym
    methname = "#{name}_history".to_sym
    self.access_history[name] = []
    define_method(methname) { self.class.access_history[name] }
  end
end
