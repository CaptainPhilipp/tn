require_relative 'instance_counter'
require_relative 'manufacture'

require_relative 'station'
require_relative 'train'
require_relative 'cargo_train'
require_relative 'passenger_train'
require_relative 'wagon'
require_relative 'cargo_wagon'
require_relative 'passenger_wagon'
require_relative 'output'

class Application
  ABORT_KEYS = ['q', 'й', nil].freeze

  TRAIN_TYPES = %w(CargoTrain PassengerTrain).freeze
  TRAIN_CLASSES = TRAIN_TYPES.map { |type| Object.const_get type }

  #
  # конструкции вида `return unless ... = gets_xxx`
  # призваны отменять действие (в том числе прерывать цикл),
  # если метод 'gets_xxx' возвращает nil
  #
  # методы вида 'gets_xxx' возвращают nil если получена пустая строка или ABORT_KEY
  #

  def main_menu
    methods_list = %w(select_station select_train create_station create_train)
    loop do
      puts "\nГлавное меню\nВведите номер комманды для её вызова"
      Output.indexed_list(methods_list)
      return unless index = gets_index
      send(methods_list[index])
    end
  end

  def create_station
    puts "\nВведите имя станции"
    return unless name = gets_nilable
    Station.new(name)
  end

  def create_train
    constant = gets_choose_train_type
    puts "\nВведите номер поезда, и опционально, его максимальную скорость"

    return unless split = gets_splited

    args  = split.map(&:to_i)
    train = constant.new(*args)
    print "\n Создан #{train.class}##{train.number}, max speed: #{train.max_speed}"
  end

  def select_station
    loop do
      puts "\nВведите id станции"
      Output.indexed_list(Station.all, :name, :trains_count)
      return unless station = gets_object(Station.all)

      puts "\nПоезда на этой станции: "
      on_station = Train.all.select { |t| t.current_station == station }

      return if on_station.empty?
      Output.indexed_list(on_station, :number, :class, :wagons_count)
    end
  end

  def select_train(trains = Train.all)
    loop do
      puts "\nВведите id поезда"
      Output.indexed_list(trains, :number, :class, :wagons_count, :location)
      return unless train = gets_object(Train.all)
      action_train(train)
    end
  end

  def action_train(train)
    methods_list = %w(add_wagons remove_wagon allocate_train)
    puts '   Выберите действие для поезда'
    show_train(train)
    loop do
      Output.indexed_list(methods_list)
      return unless index = gets_index

      meth = methods_list[index]
      puts "\nВыбран: #{meth}"
      send(meth, train)
    end
  end

  def add_wagons(train)
    wagon = train.add_wagon

    puts "#{wagon.class} added to the #{train.class}"
    puts "#{train.class} number #{train.number} have #{train.wagons.size} wagons"
  end

  def remove_wagon(train)
    return if train.wagons.size.zero?
    wagons = train.remove_wagon

    puts "#{wagons.first.class} removed from the #{train.class}"
    puts "#{train.class} number #{train.number} have #{train.wagons.size} wagons"
  end

  def allocate_train(train)
    puts "\nРазместить поезд"
    Output.indexed_list(Station.all, :name, :trains_count)
    station = gets_object(Station.all)
    return unless station

    train.allocate(station)
    puts "#{train.class}##{train.number} moved to #{station.name}"
  end

  def seed(trains: 5, stations: 10, wagons: 8)
    trains.times { TRAIN_CLASSES[rand 2].new(1000 + rand(8999)) }
    Train.all.each { |t| rand(wagons).times { t.add_wagon } }

    alphabet = (?A..?Z).to_a.shuffle
    stations.times { Station.new("Station-#{alphabet.shift * 2}") }

    Train.all.each { |train| train.allocate Station.all.sample }
  end

  private

  def gets_choose_train_type
    puts "\nВыберите тип поезда"
    Output.indexed_list(TRAIN_TYPES)
    index = gets_index
    return unless index
    TRAIN_CLASSES[index]
  end

  def show_train(train)
    puts "\nИнформация о поезде"
    puts "\n Number: `#{train.number}`, type: `#{train.class}`, " \
         "max_speed: `#{train.max_speed}` wagons: `#{train.wagons.size}`"
    puts "  location: `#{train.current_station}`"
  end

  def gets_object(collection)
    return unless index = gets_index
    collection[index]
  end

  # splited string
  def gets_splited
    return unless answer = gets_nilable
    answer.split(' ')
  end

  def gets_index
    return unless answer = gets_nilable
    answer.to_i - 1
  end

  # return nil if recieved ABORT_KEY or empty string
  def gets_nilable
    answer = gets.chomp.strip
    answer.empty? || ABORT_KEYS.include?(answer) ? nil : answer
  end
end

app = Application.new

app.seed trains: 15, stations: 10, wagons: 30

app.main_menu

puts PassengerWagon.instances.inspect
