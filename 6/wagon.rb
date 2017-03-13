class Wagon
  include InstanceCounter
  include Manufacture

  def action
    raise NotImplementedError, 'Wagon class is not defined!'
  end
end
