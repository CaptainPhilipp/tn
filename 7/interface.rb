require_relative 'gets'
require_relative 'output'

class InvalidData < Exception; end

class Interface
  TRAIN_TYPES = %w(CargoTrain PassengerTrain).freeze
  TRAIN_CLASSES = TRAIN_TYPES.map { |type| Object.const_get type }.freeze

  #
  # конструкции вида `return unless ... = Gets.xxx`
  # призваны отменять действие (в том числе прерывать цикл),
  # если метод 'Gets.xxx' возвращает nil
  #
  # методы вида 'Gets.xxx' возвращают nil если получена пустая строка или ABORT_KEY
  #

  def main_menu
    methods_list = %w(select_station select_train create_station create_train)
    loop do
      puts "\nГлавное меню\nВведите номер комманды для её вызова"
      Output.indexed_list(methods_list)
      return unless index = Gets.index(max_index: methods_list.size)
      send(methods_list[index])
    end
  end

  def create_station
    puts "\nВведите имя станции"
    return unless name = Gets.nilable
    Station.new(name)
    puts "\n Создана станция #{name}"
  rescue InvalidData => ex
    puts ex.inspect
    retry
  end

  def create_train
    return unless train_class = gets_choose_train_type
    puts "\nВведите номер поезда, и опционально, его максимальную скорость"

    return unless split = Gets.splited

    train = train_class.new(*split)
    print "\n Создан #{train.class}##{train.number}, max speed: #{train.max_speed}"
  rescue InvalidData => ex
    puts ex.inspect
    retry
  end

  def select_station
    loop do
      puts "\nВведите id станции"
      Output.indexed_list(Station.all, :name, :trains_count)
      return unless station = Gets.object(Station.all)

      select_station_trains(station)
    end
  end

  def select_train(trains = Train.all)
    loop do
      puts "\nВведите id поезда"
      Output.indexed_list(trains, :number, :class, :wagons_count, :location)
      return unless train = Gets.object(trains)
      action_train(train)
    end
  end

  def action_train(train)
    methods_list = %w(select_wagon add_wagons remove_wagon allocate_train)
    puts '   Выберите действие для поезда'
    show_train(train)
    loop do
      Output.indexed_list(methods_list)
      return unless index = Gets.index(max_index: methods_list.size)

      meth = methods_list[index]
      puts "\nВыбран: #{meth}"
      send(meth, train)
    end
  end

  def add_wagons(train)
    puts "\nВведите номер и вместительность вагона"

    return unless split = Gets.splited
    wagon = train.create_wagon(*split)
    Output.wagon_changes(:added, wagon, train)
  rescue InvalidData => ex
    puts ex.inspect
    retry
  end

  def select_wagon(train)
    Output.indexed_list(train.wagons, :number, :class, :available_space, :filled_space)
    # train.each_wagon do |w|
    #   puts "#{w.class} #{w.number} filled: #{w.filled_space} available: #{w.available_space}"
    # end
    return unless index = Gets.index(max_index: train.wagons.size)
    action_wagon(train.wagons[index])
  end

  def action_wagon(wagon)
    methods_list = %w(load_wagon unload_wagon)
    puts '   Выберите действие для вагона'
    show_wagon(wagon)
    loop do
      Output.indexed_list(methods_list)
      return unless index = Gets.index(max_index: methods_list.size)
      meth = methods_list[index]
      puts "\nВыбран: #{meth}"
      send(meth, wagon)
    end
  end

  def load_wagon(wagon)
    puts "\n Введите количество"
    return unless integer = Gets.integer
    amount = wagon.fill_space(integer)
    Output.wagon_capacity_changes(:load, wagon, amount)
  end

  def unload_wagon(wagon)
    puts "\n Введите количество"
    return unless integer = Gets.integer
    amount = wagon.release_space(integer)
    Output.wagon_capacity_changes(:unload, wagon, amount)
  end

  def remove_wagon(train)
    return if train.wagons.size.zero?
    wagons = train.remove_wagon
    Output.wagon_changes(:removed, wagons.first, train)
  end

  def allocate_train(train)
    puts "\nРазместить поезд"
    Output.indexed_list(Station.all, :name, :trains_count)
    return unless station = Gets.object(Station.all)

    train.allocate(station)
    puts "#{train.class}##{train.number} moved to #{station.name}"
  end

  def seed(trains: 5, stations: 10, wagons: 8, num_length: 4)
    trains.times { TRAIN_CLASSES[rand 2].new(Train.generate_num num_length) }
    Train.all.each { |t| rand(wagons).times { t.create_wagon Train.generate_num(num_length), 10 + rand(60) } }

    alphabet = (?A..?Z).to_a.shuffle
    stations.times { Station.new("Station-#{alphabet.shift * 2}") }

    Train.all.each { |train| train.allocate Station.all.sample }
  end

  private

  def gets_choose_train_type
    puts "\nВыберите тип поезда"
    Output.indexed_list(TRAIN_TYPES)
    return unless index = Gets.index(max_index: TRAIN_TYPES.size)
    TRAIN_CLASSES[index]
  end

  def show_train(train)
    puts "\nИнформация о поезде"
    puts "\n Number: `#{train.number}`, type: `#{train.class}`, " \
         "max_speed: `#{train.max_speed}` wagons: `#{train.wagons.size}`" \
         "location: `#{train.current_station.name}`"
  end

  def show_wagon(wagon)
    puts "\nИнформация о вагоне"
    puts "\n Number: `#{wagon.number}`, type: `#{wagon.class}`, " \
         "available_space: `#{wagon.available_space}` filled_space: `#{wagon.filled_space}`"
  end

  def select_station_trains(station)
    puts "\nПоезда на станции #{station.name}: "
    on_station = Train.all.select { |t| t.current_station == station }
    if on_station.empty?
      puts "\nПоездов нет."
      return
    end
    select_train(on_station)
  end

  def pause
    puts ' (Enter для продолжения)'
    gets
  end
end
