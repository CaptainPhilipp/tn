require_relative 'gets'
require_relative 'output'

class InvalidData < Exception; end

class Interface
  TRAIN_TYPES = %w(CargoTrain PassengerTrain).freeze
  TRAIN_CLASSES = TRAIN_TYPES.map { |type| Object.const_get type }

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
      return unless index = Gets.index(max_size: methods_list.size)
      send(methods_list[index])
    end
  end

  def create_station
    puts "\nВведите имя станции"
    return unless name = Gets.nilable
    Station.new(name)
  rescue InvalidData => ex
    puts ex.inspect
    retry
  end

  def create_train
    constant = gets_choose_train_type
    puts "\nВведите номер поезда, и опционально, его максимальную скорость"

    return unless split = Gets.splited

    train = constant.new(*split)
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

      show_station_trains(station)
    end
  end

  def select_train(trains = Train.all)
    loop do
      puts "\nВведите id поезда"
      Output.indexed_list(trains, :number, :class, :wagons_count, :location)
      return unless train = Gets.object(Train.all)
      action_train(train)
    end
  end

  def action_train(train)
    methods_list = %w(add_wagons remove_wagon allocate_train)
    puts '   Выберите действие для поезда'
    show_train(train)
    loop do
      Output.indexed_list(methods_list)
      return unless index = Gets.index

      meth = methods_list[index]
      puts "\nВыбран: #{meth}"
      send(meth, train)
    end
  end

  def add_wagons(train)
    wagon = train.add_wagon
    Output.wagon_changes(:added, wagon, train)
  end

  def remove_wagon(train)
    return if train.wagons.size.zero?
    wagons = train.remove_wagon
    Output.wagon_changes(:removed, wagons.first, train)
  end

  def allocate_train(train)
    puts "\nРазместить поезд"
    Output.indexed_list(Station.all, :name, :trains_count)
    station = Gets.object(Station.all)
    return unless station

    train.allocate(station)
    puts "#{train.class}##{train.number} moved to #{station.name}"
  end

  def seed(trains: 5, stations: 10, wagons: 8, num_length: 4)
    trains.times { TRAIN_CLASSES[rand 2].new(Train.generate_num num_length) }
    Train.all.each { |t| rand(wagons).times { t.add_wagon } }

    alphabet = (?A..?Z).to_a.shuffle
    stations.times { Station.new("Station-#{alphabet.shift * 2}") }

    Train.all.each { |train| train.allocate Station.all.sample }
  end

  private

  def gets_choose_train_type
    puts "\nВыберите тип поезда"
    Output.indexed_list(TRAIN_TYPES)
    index = Gets.index
    return unless index
    TRAIN_CLASSES[index]
  end

  def show_train(train)
    puts "\nИнформация о поезде"
    puts "\n Number: `#{train.number}`, type: `#{train.class}`, " \
         "max_speed: `#{train.max_speed}` wagons: `#{train.wagons.size}`"
    puts "  location: `#{train.current_station.name}`"
  end

  def show_station_trains(station)
    puts "\nПоезда на станции #{station.name}: "
    on_station = Train.all.select { |t| t.current_station == station }
    if on_station.empty?
      puts "\nПоездов нет."
      return
    end
    Output.indexed_list(on_station, :number, :class, :wagons_count)
    puts ' (Enter для продолжения)'
    gets
  end
end
