require          '../3/route'
require          '../3/station'
require_relative 'train'
require_relative 'cargo_train'
require_relative 'passenger_train'
require_relative 'wagon'
require_relative 'cargo_wagon'
require_relative 'passenger_wagon'

ABORT_KEYS = ['q', 'й', nil]

ACTIONS = { main:    %w[chose_station chose_train create_station create_train],
            train:   %w[add_wagons remove_wagons allocate_train],
            station: %w[allocate_train] }

TITLES  = { main_menu:      '',
            chose_station:  '- Выбрать станцию',
            chose_train:    '- Выбрать поезд',
            chose_station_action: '- Выбрать действие для станции',
            chose_train_action:   '- Выбрать действие для поезда',
            create_station: '- Создать станцию',
            create_train:   '- Создать поезд',
            allocate_train: "- Размещение поезда на станции\n" }


TIPS    = { main_menu:      "\nГлавное меню\nВведите номер комманды для её вызова",
            create_station: "\nВведите имя станции",
            create_train:   "\nВведите номер поезда, и опционально, его максимальную скорость",
            chose_station:  "\nВведите id станции",
            chose_train:    "\nВведите id поезда",
            allocate_train: "\nРазместить поезд" }

MESSAGES = { created: '>> Создан',
             abort:   " # Назад\n\n",
             exit_tip: "   [для выхода `#{ABORT_KEYS.first}` или Enter]\n\n",
           }

TRAIN_TYPES = ['CargoTrain', 'PassengerTrain']


@trains   = []
@stations = []

def main_menu
  print TITLES[:main_menu]
  chose_method(ACTIONS[:main], TIPS[:main_menu], {})
end

#
# Main methods
#

def create_station
  print TITLES[:create_station]
  create_object(@trains, TIPS[:create_station], :name) do |recieved_string|
  	Trailroad::Station.new(recieved_string)
  end
end



def create_train
  print TITLES[:create_train]

  TRAIN_TYPES

  create_object(@trains, TIPS[:create_train], :number, split: true) do |split|
  	Train.new(*split.map(&:to_i))
  end
end



# chose station from list > chose action for station
def chose_station(actions_needed = true)
  print TITLES[:chose_station]
  chose_object(@stations, :name, TIPS[:chose_station]) do |station|
    if actions_needed
      print TITLES[:chose_station_action]
    	chose_method(ACTIONS[:station], TIPS[:chose_station_action], {}, station)
    end
  end
end



# chose_object  train from list > chose action for train
def chose_train(actions_needed = true)
  print TITLES[:chose_train]
  chose_object(@trains, :number, TIPS[:chose_train]) do |train|
    if actions_needed
      print TITLES[:chose_train_action]
    	chose_method(ACTIONS[:train], TIPS[:chose_train_action], {}, train)
    end
  end
end

#
# Train methods
#

def add_wagons(train)
  print TITLES[:add_wagons]
  wagon = train.add_wagon
  puts "#{wagon.class} added to the #{train.class}"
  puts "#{train.class} number #{train.number} have #{train.wagons.size} wagons"
end



def remove_wagons(train)
  print TITLES[:remove_wagons]
  wagon = train.remove_wagon
  puts wagon.inspect
  puts "#{wagon.class} removed from the #{train.class}"
  puts "#{train.class} number #{train.number} have #{train.wagons.size} wagons"
end

#
# Train and Station methods
#

# allocate train into station
def allocate_train(train_or_station)
  print TITLES[:allocate_train]
  case train_or_station
  when Train
    train   = train_or_station
    station = chose_station(false)
  when Trailroad::
    Station
    station = train_or_station
    train   = chose_train(false)
  end
  puts
  "\n#{train.inspect} <> #{station.inspect}"
  train.allocate_on(station)
end

#
# for private / protected
#

def create_object(collection, repeteable_tip, inspect_methods, loop_options = {})
  object = nil
  gets_loop(repeteable_tip, loop_options) do |recieved|
  	object = yield(recieved)
    collection << object

    inspects = [*inspect_methods].inject([]) { |c, m| c << "#{m}: #{object.send(m)}"}
    print "#{MESSAGES[:created]} #{object.class}; #{inspects * ', '}"
  end
  object
end



# chose object
# if block given => yield object in gets_loop
# else return object
def chose_object(collection, name_method, repeteable_tip)
  titles     = collection.map(&name_method) # method, that returns name of each object
  tips_block = get_tips_block(titles, repeteable_tip)

  object = nil
  gets_loop(tips_block, get_index: true, loop: false) do |index|
    object = collection[index - 1]
    yield(object) if block_given?
  end
  object
end



# chose and send method from list
def chose_method(methods_list, repeteable_tip, options, *args)
  default    = {get_index: true, loop: true}
  options    = default.merge(options)
  tips_block = get_tips_block(methods_list, repeteable_tip)

  gets_loop(tips_block, options) do |index|
    send(methods_list[index - 1], *args)
  end
end



def chose_from_list(list, repeteable_tip)
  tips_block = get_tips_block(actions_list, repeteable_tip)

  gets_loop(tips_block, options) do |index|

  end
end



# > loop while gets;
# > if ABORT_KEY given => breaks loop
# > yielding `gets`
#
# > `loop: false`     => only one loop
# > `split: true`     => yielding gets.split
# > `get_index: true` => yielding gets.split.first.to_i
#
# print `message_or_proc` each iteration, but before `gets`
def gets_loop(repeteable_tip, options = {})
  result = nil
  begin
    print_inloop_tip(repeteable_tip)
    case (gets_input = gets.chomp.strip).empty? ? nil : gets_input
    when *ABORT_KEYS
      print MESSAGES[:abort]
      break
    else
      gets_input = gets_input.split(' ') if options[:get_index] || options[:split]
      gets_input = gets_input.first.to_i if options[:get_index]

      yield(gets_input)
    end
  end while options[:loop].nil? || options[:loop]
end



# proc for calling in `.gets_loop`s loop
def get_tips_block(list, message)
  ->{
      puts message
      list.each_with_index { |item, i| puts " [#{i + 1}] #{item}" }
    }
end



# calling proc for `.gets_loop`s loop
# message or block of messages
def print_inloop_tip(message_or_proc)
  case message_or_proc
  when String
    puts message_or_proc + MESSAGES[:exit_tip]
  when Proc
    message_or_proc.call
  end
end



5.times  { @trains << Object.const_get(TRAIN_TYPES[rand 2]).new(1000 + rand(8999)) }
alphabet = (?A..?Z).to_a.shuffle
10.times { @stations << Trailroad::Station.new("Station-#{alphabet.shift * 2}") }

main_menu
