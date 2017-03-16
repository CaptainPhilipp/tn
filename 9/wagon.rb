class Wagon
  include InstanceCounter
  include Manufacture

  attr_reader :number, :capacity, :filled_space

  def initialize(number, capacity = 0)
    @capacity = capacity.to_i.freeze
    @filled_space = 0
    @number = number
    validate!
  end

  def fill_space(amount)
    amount = [available_space, amount.abs].min
    @filled_space += convert(amount)
    amount
  end

  def release_space(amount)
    amount = [filled_space, amount.abs].min
    @filled_space -= convert(amount)
    amount
  end

  def available_space
    @capacity - @filled_space
  end

  def action
    raise NotImplementedError, 'Nested Wagon class is not defined!'
  end

  def valid?
    validate!
  rescue InvalidData
    false
  end

  private

  # для переопределения в наследных классах
  def convert(amount)
    amount
  end

  def validate!
    raise InvalidData, 'Capacity <= 0' if @capacity <= 0
    true
  end
end
