class CargoTrain < Train

  def load_cargo
    puts 'Подготовиться к погрузке/разгрузке!'
    wagons_action
  end

  protected

  def wagon_class
    CargoWagon
  end
end
