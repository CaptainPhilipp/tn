class Wagon
  include InstanceCounter
  include Manufacture
  include Validation
  attr_reader :number, :capacity, :filled_space

  validate :number, /\A[a-z\d]{3}-?[a-z\d]{2}\z/i
  validate :capacity
  validate :capacity, 1..1000

  def initialize(number, capacity = 0)
  # def initialize(number, capacity = nil)
  # @capacity = capacity
    @capacity = capacity.to_i.freeze
    @filled_space = 0
    @number = number.to_s
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

  private

  # для переопределения в наследных классах
  def convert(amount)
    amount
  end
end
