module InstanceCounter
  # Создать модуль InstanceCounter, содержащий следующие методы класса и инстанс-методы, которые подключаются автоматически при вызове include в классе:
  # ::instances ол-во экземпляров данного класса
  # #register_instance увеличивает счетчик кол-ва экземпляров класса
  #   подключаются автоматически при вызове include в классе
  #   можно вызвать из конструктора
  #   не публичный

  # сработает только с классами, где initialize не определен,
  # потому дя очевидности уберу отсюда
  # def initialize
  #   register_instance
  #   super
  # end

  @@instances = 0

  def self.instances
    @@instances
  end

  protected

  def register_instance
    @@instances += 1
  end
end
