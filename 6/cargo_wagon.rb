class CargoWagon < Wagon
  include InstanceCounter

  def action
    puts 'Вагон готов к погрузке/выгрузке груза'
  end
end
