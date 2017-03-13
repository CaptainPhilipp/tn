class Train
  include InstanceCounter
  include Manufacture
  attr_reader :number, :type, :wagons, :speed, :max_speed, :current_station
  MAX_SPEED = 120
  @@all = {}

  def initialize(number, max_speed = MAX_SPEED)
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

  class << self
    def all
      @@all.values
    end

    def find(number)
      @@all[number]
    end
  end

  protected

  def wagon_class
    raise NotImplementedError, 'Nested Train class is not defined!'
  end

  def wagons_action
    @wagons.each &:action
  end

  private

  def stop?
    @speed.zero?
  end
end # Station
