class Train
  include InstanceCounter
  include Manufacture
  include Validation
  attr_reader :number, :wagons, :speed, :max_speed, :current_station

  validate :number, /\A[a-z\d]{3}-?[a-z\d]{2}\z/i
  validate :max_speed, 0, :<=

  MAX_SPEED = 120
  @@all = {}

  def initialize(number, max_speed = MAX_SPEED)
    @number    = number.to_s
    @wagons    = []
    @max_speed = max_speed.to_i
    @current_station = nil
    @speed = 0

    validate!
    @@all[@number] = self
  end

  def add_wagon(wagon)
    return false unless stop? && wagon.is_a?(wagon_class)
    @wagons << wagon
    wagon
  end

  def create_wagon(*args)
    add_wagon(wagon_class.new(*args))
  end

  def remove_wagon(count = 1)
    return false unless stop?
    @wagons.pop(count)
  end

  # просто что бы вызывать одним методом из main, не усложняя там код
  def wagons_count
    wagons.size
  end

  def each_wagon
    @wagons.each_with_index { |wagon, index| yield wagon, index }
  end

  def location
    current_station.name if current_station
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
      @@all[number.to_s]
    end

    def generate_num(length = 4)
      from = 10**(length - 1)
      upto = 10**length - from - 1
      from + rand(upto)
    end
  end

  protected

  def wagon_class
    raise NotImplementedError, 'Nested Train class is not defined!'
  end

  def wagons_action
    @wagons.each(&:action)
  end

  private

  def stop?
    @speed.zero?
  end
end # Station
