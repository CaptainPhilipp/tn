module InstanceCounter
  def self.included(klass)
    klass.extend ClassMethods
    klass.include InstanceMethods
  end
  
  module ClassMethods
    @instances = 0
    
    def instances
      @instances
    end
    
    protected
    
    def register_instance
      @instances += 1
    end
  end

  module InstanceMethods
    protected
    
    def register_instance
      self.class.register_instance
    end
  end # InstanceMethods
end
