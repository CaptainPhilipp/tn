class InvalidData < RuntimeError; end
class InvalidPresense < InvalidData; end
class InvalidFormat   < InvalidData; end
class InvalidType     < InvalidData; end
class InvalidVolume   < InvalidData; end

module Validation
  def self.included(klass)
    klass.include Includeable
    klass.extend  Extendeable
  end

  module Includeable
    def validate!
      tasks = self.class.class_variable_get(:@@validating_tasks)
      tasks.each { |name, task| duck_type_send(name, task) }
    end

    def valid?
      validate!
    rescue InvalidData
      false
    end

    private

    def duck_type_send(name, task)
      current_value = instance_variable_get("@#{name}".to_sym)
      meth = duck_type(task.requirement)
      self.class.send(meth, name, current_value, task)
    end

    def duck_type(requirement)
      type =
        case requirement
        when nil     then 'presense'
        when Regexp  then 'format'
        when Class   then 'type'
        when Range   then 'range'
        when Integer then 'integer'
        else raise ArgumentError
        end
      "validate_#{type}".to_sym
    end
  end # Includeable

  module Extendeable
    # validate :var           # not nil or not empty
    # validate :var, /regexp/ # #=~()
    # validate :var, Class    # #is_a?
    # validate :var, 0..12    # #cover?
    # validate :var, 10, :<   # "10 sould_be less(<) then @var"
    def validate(name, requirement = nil, argument = nil)
      set_task(name, requirement, argument)
    end

    private

    ValidateTask = Struct.new :requirement, :argument

    def set_task(name, requirement, argument)
      task = ValidateTask.new(requirement, argument)

      if class_variable_defined?(:@@validating_tasks)
        tasks = class_variable_get(:@@validating_tasks)
        tasks[name] = task
        class_variable_set(:@@validating_tasks, tasks)

      else
        class_variable_set(:@@validating_tasks, name => task)
      end
    end

    def validate_presense(name, value, _)
      return unless value.nil? || (value.respond_to?(:empty?) && value.empty?)
      raise InvalidPresense, "#{name} is nil or empty (#{value})"
    end

    def validate_format(name, current_value, task)
      return if current_value =~ task.requirement
      raise InvalidFormat, "#{name} has wrong format"
    end

    def validate_type(name, current_value, task)
      return if current_value.is_a? task.requirement
      raise InvalidType, "#{name} is a #{current_value.class}, not #{task.type}"
    end

    def validate_range(name, current_value, task)
      return if task.requirement.cover? current_value
      raise InvalidVolume, "#{name} (#{current_value}) " \
                           "not in #{task.requirement}"
    end

    def validate_integer(name, current_value, task)
      return if task.requirement.send(task.argument, current_value)
      raise InvalidVolume, "#{name}(#{current_value}): #{task.requirement} " \
                           "must be #{task.argument} #{current_value}"
    end
  end # Extendeable
end
