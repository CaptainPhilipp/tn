class Wagon
  attr_reader
  WAGON_TYPE = self.class.to_s

  def initialize; end

  # метод для переопределения
  # будет вызываться другими классами
  def action
    raise "class not defined!"
  end
end
