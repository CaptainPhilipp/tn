module InstanceCounter
  # Создать модуль InstanceCounter, содержащий следующие методы класса и инстанс-методы, которые подключаются автоматически при вызове include в классе:
  # ::instances ол-во экземпляров данного класса
  # #register_instance увеличивает счетчик кол-ва экземпляров класса
    # подключаются автоматически при вызове include в классе
    # можно вызвать из конструктора
    # не публичный

  @@instances_count = 0

  # сработает только с классами, где initialize не определен,
  # потому дя очевидности уберу отсюда
  # def initialize
  #   register_instance
  #   super
  # end

  def instances
    self.instances
  end

  def self.instances
    @@instances_count
  end

  # вот тут не уверен: с одной стороны, он для принимающих миксин, с другой стороны - вызывается из самого миксина
  private

  def register_instance
    @@instances_count += 1
  end
end
