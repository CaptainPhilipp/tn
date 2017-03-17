module InstanceCounter
  def self.included(klass)
    klass.extend ClassMethods
    klass.prepend InstanceMethods
  end

  module ClassMethods
    extend Accessors
    attr_accessor_with_history :instances
  end

  module InstanceMethods
    def initialize(*args)
      self.class.instances ||= 0
      self.class.instances  += 1
      super
    end
  end # InstanceMethods
end
