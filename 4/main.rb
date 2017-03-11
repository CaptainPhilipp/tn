require_relative 'station'
require_relative 'train'
require_relative 'cargo_train'
require_relative 'passenger_train'
require_relative 'wagon'
require_relative 'cargo_wagon'
require_relative 'passenger_wagon'

class Application
  ABORT_KEYS = ['q', 'й', nil]

  ACTIONS = { main:    %w[select_station select_train create_station create_train],
              train:   %w[add_wagons remove_wagon allocate_train],
              station: %w[allocate_train] }

  TIPS    = { main_Application:      "\nГлавное меню\nВведите номер комманды для её вызова",
              create_station: "\nВведите имя станции",
              create_train:   "\nВведите номер поезда, и опционально, его максимальную скорость",
              select_station: "\nВведите id станции",
              select_train_action: "   Выберите действие для поезда",
              train_info:     "\nИнформация о поезде",
              trains_on_station:   "\nПоезда на этой станции: ",
              select_train:   "\nВведите id поезда",
              continue:       "\nНажмите `Enter` для продолжения",
              chosen:         "\nВыбран: ",
              allocate_train: "\nРазместить поезд",
              select_train_type:   "\nВыберите тип поезда"}

  TRAIN_TYPES = ['CargoTrain', 'PassengerTrain']

  #
  # Main methods
  #

  def initialize
    @trains, @stations = [], []
  end

  def main_menu
    loop do
      puts TIPS[:main_Application]
      print_indexed_list(ACTIONS[:main])
      return unless index = gets_index
      send(ACTIONS[:main][index])
    end
  end

  def create_station
    puts TIPS[:create_station]
    return unless name = ggets
    @stations << Trailroad::Station.new(name)
  end

  def create_train
    puts TIPS[:select_train_type]
    print_indexed_list(TRAIN_TYPES)
    train_constant = Object.const_get(TRAIN_TYPES[gets_index])

    puts TIPS[:create_train]
    return unless split = gets_split_args
    name_n_speed = split.map(&:to_i)
    train = train_constant.new(*name_n_speed)
    @trains << train
    print "\n Создан #{train.class}##{train.number}, max speed: #{train.max_speed}"
  end

  def select_station
    loop do
      puts TIPS[:select_station]
      return unless station = gets_object(@stations, :name, :trains_count)
      puts TIPS[:trains_on_station]
      on_station = @trains.select{ |t| t.current_station == station }
      select_train(on_station)
    end
  end

  def select_train(trains = @trains)
    loop do
      puts TIPS[:select_train]
      return unless train = gets_object(trains, :number, :class, :wagons_count)
      action_train(train)
    end
  end

  def action_train(train)
    show_train(train)
    loop do
      puts TIPS[:select_train_action]
      print_indexed_list(ACTIONS[:train])
      return unless index = gets_index
      meth = ACTIONS[:train][index]
      puts "#{TIPS[:chosen]} #{meth}"
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
    wagon = train.remove_wagon
    puts "#{wagon.class} removed from the #{train.class}"
    puts "#{train.class} number #{train.number} have #{train.wagons.size} wagons"
  end

  def allocate_train(train)
    puts TIPS[:allocate_train]
    return unless station = gets_object(@stations, :name, :trains_count)
    station.train_incoming(train)
    puts "#{train.class}##{train.number} moved to #{station.name}"
  end

  def seed
    5.times  { @trains << Object.const_get(TRAIN_TYPES[rand 2]).new(1000 + rand(8999)) }
    alphabet = (?A..?Z).to_a.shuffle
    10.times { @stations << Trailroad::Station.new("Station-#{alphabet.shift * 2}") }
  end

  private
  # потому что наследников нет.

  def show_train(train)
    puts TIPS[:train_info]
    t = train
    puts "\n Number: `#{t.number}`, type: `#{t.class}`, max_speed: `#{t.max_speed}`" +
            "wagons: `#{t.wagons.size}`"
    location = @stations.select{ |s| s.trains.include? train }
    puts "  location: `#{location.first}`" unless location.empty?
  end

  # private

  # показывает элементы коллекции, вызывает к ним инфометоды,
  # представляет в виде ровной таблички
  def print_indexed_list(collection, *info_methods)
    rows = []
    collection.each_with_index do |item, i|
      row = [" [#{i + 1}] "]
      info_methods.each { |method| row << "#{method}: `#{item.send(method)}`" }
      row.insert(1, item) if row.size == 1 && item.is_a?(String)
      rows << row
    end
    max_len = max_length_of_columns(rows)
    puts rows.map{ |a| a.map.with_index{ |s, i| s.ljust max_len[i] } * ' ' }
  end
  #
  # считает максимальную длину каждого столбца
  def max_length_of_columns(rows)
    max_len = []
    columns_count = rows.first.size
    rows_count    = rows.size
    columns_count.times do |c|
      column = []
      rows_count.times { |r| column << rows[r][c] }
      max_len << column.inject(1) { |memo, row| [row.size, memo].max }
    end
    max_len
  end

  def gets_object(collection, *info_methods)
    print_indexed_list(collection, *info_methods)
    return unless index = gets_index
    collection[index]
  end

  def gets_split_args
    return unless answer = ggets
    answer.split(' ')
  end

  def gets_index
    return unless answer = ggets
    answer.to_i - 1
  end

  def ggets
    answer = gets.chomp.strip
    answer.empty? || ABORT_KEYS.include?(answer) ? nil : answer
  end
end

app = Application.new

app.seed

app.main_menu
