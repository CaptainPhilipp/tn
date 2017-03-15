class PassengerWagon < Wagon
  include InstanceCounter

  def fill_space(amount)
    super(amount.to_i)
  end

  def release_space(amount)
    super(amount.to_i)
  end

  alias place_passenger fill_space

  alias evict_passenger release_space


  def action
    puts 'Вагон (открыл|закрыл) двери' # dummy
  end
end
