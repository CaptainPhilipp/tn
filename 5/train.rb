class Train
  include Debug
  include InstanceCounter
  include Manufacture
  attr_reader :number, :type, :wagons, :speed, :max_speed, :current_station
  MAX_SPEED = 120
  @@all = {}

  def initialize(number, max_speed = MAX_SPEED)
    register_instance

    @number    = number
    @wagons    = []
    @max_speed = max_speed
    @current_station = nil

    @speed = 0
    @@all[number] = self
  end

  def add_wagon(wagon = nil)
    return false unless stop? && (wagon.nil? || wagon.is_a?(wagon_class))
    wagon = wagon_class.new if wagon.nil?
    @wagons << wagon
    wagon
  end

  def remove_wagon(count = 1)
    return false unless stop?
    @wagons.pop(count)
  end

  # просто что бы вызывать одним методом из main, не усложняя там код
  def wagons_count
    wagons.size
  end

  def location
    current_station.name
  end

  def allocate(station)
    return unless station.is_a? Station

    @current_station.train_departure(self) unless @current_station.nil?

    station.train_incoming(self)
    @current_station = station
  end

  def self.all
    @@all.values
  end

  def self.find(number)
    @@all[number]
  end

  protected

  # метод обязует переопределять его в дочерних классах
  # однозначно protected
  def wagon_class
    raise 'class not defined!'
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
