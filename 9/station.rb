class Station
  include InstanceCounter
  include Validation
  attr_reader :trains, :name

  validate :name, /\A[\w\d\s-]{3,20}\z/
  
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

  def each_train
    @trains.each_with_index { |train, index| yield train, index }
  end

  class << self
    attr_reader :all
  end
end # Station
