module Manufacture
  PATTERN = /[\w\s-]+/
  def included(klass) # что бы небыло лишней путаницы каким методом подключать
    klass.prepend self
  end

  attr_accessor :manufacture

  def validate! # обертка для суперметода из класса
    super
    text = 'Wrong format'
    raise InvalidData, text unless manufacture.nil? || manufacture =~ PATTERN
    true
  end
end
