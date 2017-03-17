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
      tasks = self.class.class_variable_get(:@@validating_tasks)
      tasks.each do |name, task|
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

    # validate :var, :presence
    # validate :var, :format, /regexp/
    # validate :var, :type,   Class     # or :Class 'Class'
    def validate(name, type, option = nil)
      task = ValidateTask.new("validate_#{type}".to_sym, option)

      if class_variable_defined?(:@@validating_tasks)
        tasks = class_variable_get(:@@validating_tasks)
        tasks[name] = task
        class_variable_set(:@@validating_tasks, tasks)

      else
        class_variable_set(:@@validating_tasks, name => task)
      end
    end

    private

    # not nil or empty
    def validate_presense(name, value, _)
      return unless value.nil? || (value.respond_to?(:empty?) && value.empty?)
      raise InvalidPresense, "#{name} is nil or empty (#{value})"
    end

    # regex
    def validate_format(name, value, pattern)
      return if value =~ pattern
      raise InvalidFormat, "#{name} has wrong format"
    end

    # is_a? Type
    def validate_type(name, value, type)
      return if value.is_a? type

      raise InvalidType, "#{name} is a #{value.class} not a #{type}"
    end
  end # Extendeable
end
