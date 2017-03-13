class PassengerWagon < Wagon
  include InstanceCounter

  def action
    puts 'Вагон (открыл|закрыл) двери' # dummy
  end
end
