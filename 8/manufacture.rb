module Manufacture
  MANUFACTURE_PATTERN = /[\w\s-]+/
  def included(klass) # что бы небыло лишней путаницы каким методом какой модуль подключать
    klass.prepend self
  end

  attr_accessor :manufacture

  def validate! # обертка для суперметода из класса, к которому подвешивается модуль
    super
    raise InvalidData, 'Wrong format' unless manufacture.nil? || manufacture =~ MANUFACTURE_PATTERN
    true
  end
end
