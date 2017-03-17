class InvalidData < RuntimeError; end
class InvalidPresense < InvalidData; end
class InvalidFormat   < InvalidData; end
class InvalidType     < InvalidData; end

module Validation
  def self.included(klass)
    klass.include InstanceMethods
    klass.extend  ClassMethods
  end

  module InstanceMethods
    def validate!
      self.class.validating_tasks.each do |name, task|
        value = instance_variable_get("@#{name}".to_sym)
        self.class.send(task.validate_method, name, value, task.option)
        true
      end
    end

    def valid?
      validate!
    rescue InvalidData
      false
    end
  end # includeable

  module ClassMethods
    ValidateTask = Struct.new :validate_method, :option
    attr_accessor :validating_tasks

    # validate :var, :presence
    # validate :var, :format, /regexp/
    # validate :var, :type,   Class     # or :Class 'Class'
    def validate(name, type, option = nil)
      @validating_tasks ||= {}
      @validating_tasks[name] = ValidateTask.new("validate_#{type}".to_sym, option)
    end
    
    private

    # not nil or empty
    def validate_presense(name, value, _)
      return unless value.nil? || (value.respond_to?(:empty?) && value.empty?)
      puts value.inspect
      raise InvalidPresense, name
    end

    # regex
    def validate_format(name, value, pattern)
      raise InvalidFormat, name if value !~ pattern
    end

    # is_a? Type
    def validate_type(name, value, type)
      raise InvalidType, name unless value.is_a? type
    end
  end # Extendeable
end
