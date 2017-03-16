class CargoWagon < Wagon
  include InstanceCounter

  alias place_cargo fill_space

  alias unload_cargo release_space

  def action
    puts 'Вагон готов к погрузке/выгрузке груза' # dummy
  end

  private

  def convert(amount)
    amount.to_f
  end
end
