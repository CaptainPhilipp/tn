class Wagon
  include InstanceCounter
  include Manufacture

  def action
     raise NotImplementedError, 'Nested Wagon class is not defined!'
  end
end
