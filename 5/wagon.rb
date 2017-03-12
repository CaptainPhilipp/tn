class Wagon
  include InstanceCounter
  include Manufacture

  def initialize
    register_instance
  end
  # метод для переопределения
  # будет вызываться другими классами
  def action
    raise NotImplementedError, "Wagon class is not defined!"
  end
end
