class CargoWagon < Wagon
  include InstanceCounter

  def fill_space(amount)
    super(amount.to_f)
  end

  def release_space(amount)
    super(amount.to_f)
  end

  alias place_cargo fill_space

  alias unload_cargo release_space

  def action
    puts 'Вагон готов к погрузке/выгрузке груза'
  end
end
