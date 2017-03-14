class Train
  include InstanceCounter
  include Manufacture
  attr_reader :number, :wagons, :speed, :max_speed, :current_station
  NUMBER_PATTERN = /\A[a-z\d]{3}-?[a-z\d]{2}\z/i
  MAX_SPEED = 120
  @@all = {}

  def initialize(number, max_speed = MAX_SPEED)
    @number    = number.to_s # коль тире позволено
    @wagons    = []
    @max_speed = max_speed.to_i
    @current_station = nil
    @speed = 0

    validate!
    @@all[@number] = self
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

  def valid?
    validate!
  rescue InvalidData
    false
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

  def validate!
    raise InvalidData, "Number format wrong#{@number}" if @number !~ NUMBER_PATTERN
    raise InvalidData, 'Max speed <= 0'        if @max_speed && @max_speed <= 0
    # raise InvalidData, 'Station wrong object'  unless @current_station.nil? || @current_station.is_a?(Station)
    # raise InvalidData, 'Wrong wagons objects'  unless @wagons.empty? || @wagons.all? { |s| s.is_a? Wagon }
    true
  end

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
