class Station
  include Debug
  include InstanceCounter
  attr_reader :trains, :name

  @@all = []

  def initialize(name)
    register_instance

    @name = name
    @trains = []
    @@all << self
  end

  def train_incoming(train)
    raise ArgumentError, "must be Train" unless train.is_a? Train
    @trains << train
  end

  alias new_train train_incoming # как полагается удобнее располагать алиасы?

  def train_departure(train)
    @trains.delete(train)
  end

  alias remove_train train_departure

  # тупо что бы вызывать одним методом из main, не усложняя там код
  def trains_count
    @trains.size
  end

  # список поездов на станции по типу: кол-во грузовых, пассажирских
  def trains_by_type(type)
    @trains.select{ |t| t.type == type }
  end

  def self.all
    @@all
  end
end # Station
