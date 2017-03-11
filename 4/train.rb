require '../3/train'

class Train < Trailroad::Train
  attr_reader :number, :type, :wagons, :speed, :route

  MAX_SPEED = 120

  def initialize(number, max_speed = MAX_SPEED)
    @number    = number
    @wagons    = []
    @max_speed = max_speed

    @speed = 0
  end

  def add_wagon
    return false unless stop?
    @wagons << (wagon = wagon_class.new)
    wagon
  end

  def remove_wagon(count = 1)
    return false unless stop?
    result = @wagons.pop(count)
    result.first
  end

  # тупо что бы вызывать одним методом из main, не усложняя там код
  def wagons_count
    wagons.size
  end

  protected

  # метод обязует переопределять его в дочерних классах
  # однозначно protected
  def wagon_class
    raise "class not defined!"
  end

  def wagons_action
    # @wagons.all { |w| w.action }
    @wagons.each &:action
  end

  private
  # продублирован в этом файле просто для примера, по скольку это относится
  # к текущему уроку
  #
  # 1) метод является базовым поведением Train
  # 2) не будет переопределяться в дочерних классах,
  # 3) и не вызывается из дочерних классов
  # потому я бы добавил его в private, хотя
  # после прослушивания лекции у меня в этом есть сомнения
  # тем не менее, я считаю логичным именно private в данном случае
  # а как нужно?
  def stop?
    @speed.zero?
  end
end # Station
