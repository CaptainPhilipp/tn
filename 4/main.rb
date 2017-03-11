require_relative 'station'
require_relative 'train'
require_relative 'cargo_train'
require_relative 'passenger_train'
require_relative 'wagon'
require_relative 'cargo_wagon'
require_relative 'passenger_wagon'
require_relative 'output'

class Application
  include Output

  ABORT_KEYS = ['q', 'й', nil]

  TRAIN_TYPES = %w[CargoTrain PassengerTrain]
  TRAIN_CLASSES = TRAIN_TYPES.map{ |type| Object.const_get type }

  #
  # конструкции вида `return unless ... = gets_xxx`
  # призваны отменять действие (в том числе прерывать цикл),
  # если метод 'gets_xxx' возвращает nil
  #
  # методы вида 'gets_xxx' возвращают nil если получена пустая строка или ABORT_KEY
  #

  def main_menu
    methods_list =  %w[select_station select_train create_station create_train]
    loop do
      puts "\nГлавное меню\nВведите номер комманды для её вызова"
      return unless index = gets_and_tips(:index, methods_list)
      send(methods_list[index])
    end
  end



  def create_station
    puts "\nВведите имя станции"
    return unless name = gets_nilable
    Station.new(name)
  end



  # chose type
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
      station = gets_and_tips(:object, Station.all, [:name, :trains_count])
      return unless station

      puts "\nПоезда на этой станции: "
      on_station = Train.all.select{ |t| t.current_station == station }

      return if on_station.empty?
      print_indexed_list(on_station, :number, :class, :wagons_count)
    end
  end



  def select_train(trains = Train.all)
    loop do
      puts "\nВведите id поезда"
      train = gets_and_tips(:object, Train.all, [:number, :class, :wagons_count])
      return unless train
      puts train.inspect
      action_train(train)
    end
  end



  def action_train(train)
    methods_list = %w[add_wagons remove_wagon allocate_train]
    puts "   Выберите действие для поезда"
    show_train(train)
    loop do
      index = gets_and_tips(:index, methods_list)
      return unless index

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
    station = gets_and_tips(:object, Station.all, [:name, :trains_count])
    return unless station

    train.allocate(station)
    puts "#{train.class}##{train.number} moved to #{station.name}"
  end



  def seed
    5.times  { TRAIN_CLASSES[rand 2].new(1000 + rand(8999)) }
    alphabet = (?A..?Z).to_a.shuffle
    10.times { Station.new("Station-#{alphabet.shift * 2}") }
  end



  private # потому что наследников нет.

  def gets_choose_train_type
    puts "\nВыберите тип поезда"
    index = gets_and_tips(:index, TRAIN_TYPES)
    return unless index
    TRAIN_CLASSES[index]
  end



  def show_train(train)
    puts "\nИнформация о поезде"

    puts "\n Number: `#{train.number}`, type: `#{train.class}`, " +
            "max_speed: `#{train.max_speed}` wagons: `#{train.wagons.size}`"

    puts "  location: `#{train.current_station}`"
  end



  # just for DRY
  # show list of tips and send gets_xxx method
  # return nilable gets (nil if recieved empty or ABORT KEY)
  def gets_and_tips(gets_method, collection, info_methods = nil)
    print_indexed_list(collection, *info_methods) if collection

    case meth = "gets_#{gets_method}"
    when 'gets_object'
      send(meth, collection)
    when 'gets_splited', 'gets_index', 'gets_nilable'
      send(meth)
    else
      raise "NoMethod"
    end
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
    (answer.empty? || ABORT_KEYS.include?(answer)) ? nil : answer
  end
end

app = Application.new

app.seed

app.main_menu
