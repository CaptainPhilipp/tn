class Wagon
  include InstanceCounter
  include Manufacture

  attr_reader :capacity, :filled_space

  def initialize(capacity = 0)
    @capacity = capacity.freeze
    @filled_space = 0
  end

  def fill_space(amount)
    amount = [amount, @capacity].min
    @filled_space += amount
    amount
  end

  def release_space(amount)
    amount = [0, amount].min
    @filled_space -= amount
    amount
  end

  def available_space
    @capacity - @filled_space
  end

  def action
    raise NotImplementedError, 'Nested Wagon class is not defined!'
  end
end
