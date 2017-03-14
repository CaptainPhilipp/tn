class Station
  include InstanceCounter
  attr_reader :trains, :name
  STRING_LENGTH = (3..20)

  @all = []

  def initialize(name)
    @name = name
    @trains = []

    validate!
    self.class.all << self
  end

  def train_incoming(train)
    raise ArgumentError, 'must be Train' unless train.is_a? Train
    @trains << train
  end

  alias new_train train_incoming

  def train_departure(train)
    @trains.delete(train)
  end

  alias remove_train train_departure

  # просто что бы вызывать одним методом из Output, не усложняя там код
  def trains_count
    @trains.size
  end

  def trains_by_type(type)
    @trains.select { |t| t.type == type }
  end

  def valid?
    validate!
  rescue InvalidData
    false
  end

  class << self
    attr_reader :all
  end

  protected

  def validate!
    raise InvalidData, "Name must have length #{STRING_LENGTH}" unless STRING_LENGTH.cover?(@name.size)
    raise InvalidData, 'Wrong station objects' unless @trains.empty? || @trains.all? { |s| s.is_a? Train }
    true
  end
end # Station
