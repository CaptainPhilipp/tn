class PassengerWagon < Wagon
  include InstanceCounter

  alias place_passenger fill_space

  alias evict_passenger release_space

  def action
    puts 'Вагон (открыл|закрыл) двери' # dummy
  end

  private

  def convert(amount)
    amount.to_i
  end
end
