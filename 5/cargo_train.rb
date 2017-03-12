class CargoTrain < Train
  # метод для визуализации ситуации
  # когда просто алиаса `alias load_cargo wagons_action` недостаточно,
  # а переопределение с super не подходит тк нужно подходящее говорящее имя
  #
  # Если действие, общее для вагонов разных типов,
  # должно немного отличаться от действий вагонов других типов.
  def load_cargo
    puts 'Подготовиться к погрузке/разгрузке!'
    wagons_action
  end

  protected

  def wagon_class
    CargoWagon
  end
end
