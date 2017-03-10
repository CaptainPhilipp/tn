require          '../3/route'
require          '../3/station'
require_relative 'train'
require_relative 'cargo_train'
require_relative 'passenger_train'
require_relative 'wagon'
require_relative 'cargo_wagon'
require_relative 'passenger_wagon'

ABORT_KEYS = ['q', 'й', nil]

ACTIONS = {main:    %w[chose_station chose_train create_station create_train],
           train:   %w[add_wagons remove_wagons allocate_train],
           station: %w[allocate_train]}

TITLES  = {main_menu:      'Главное меню',
           create_station: '- Создать станцию',
           create_train:   '- Создать поезд'}

TIPS    = {main_menu:      'Введите номер комманды для её вызова',
           create_station: 'Введите имя станции',
           create_train:   'Введите номер поезда, и опционально, его максимальную скорость',
           chose_station:  'Введите id станции',
           chose_train:    'Введите id поезда'}

MESSAGES = {created: '>> Создан',
            abort:   " # Отмена\n\n",
        	exit_tip: '', #{}"   [для выхода `#{ABORT_KEYS.first}` или Enter]\n\n",
        	}


@trains   = []
@stations = []

def main_menu
  messages = get_messages_proc(methods, TIPS[:main_menu])
  puts TITLES[:main_menu]
  chose_action_loop(ACTIONS[:main])
end

# 
# Main methods
# 

def create_station
  puts TITLES[:create_station]
  repeteable_tip = TIPS[:create_station]

  create_object(@trains, repeteable_tip, :name) do |recieved_string|
  	Trailroad::Station.new(recieved_string)
  end
end



def create_train
  puts TITLES[:create_train]
  repeteable_tip = TIPS[:create_train]

  create_object(@trains, repeteable_tip, :number, split: true) do |recieved_split|
  	Train.new(*recieved.map(&:to_i))
  end
end



# chose station from list > chose action for station
def chose_station(chose_action_needed = true)
  chose_object(@trains, :number, TIPS[:chose_station]) do |station|
  	chose_action_loop(ACTIONS[:station], station) if chose_action_needed
  end
end



# chose_object  train from list > chose action for train
def chose_train(chose_action_needed = true)
  chose_object(@trains, :number, TIPS[:chose_train]) do |train|
  	chose_action_loop(ACTIONS[:train], train) if chose_action_needed
  end
end

# 
# Train methods
# 

def add_wagons(train)
  puts TITLES[:add_wagons]
  wagon = train.add_wagon
  puts "#{wagon.class} added to the #{train.class}"
  puts "#{train.class} number #{train.number} have #{train.wagons.size} wagons"
end



def remove_wagons(train)
  puts TITLES[:remove_wagons]
  train.remove_wagon
  puts "#{wagon.class} removed to the #{train.class}"
  puts "#{train.class} number #{train.number} have #{train.wagons.size} wagons"
end

# 
# Train and Station methods
# 

# allocate train into station
def allocate_train(train_or_station)
  puts TITLES[:allocate_train]
  case train_or_station
  when Train
    train   = train_or_station
    station = chose_station(call_actions: false)
  when Station
    station = train_or_station
    train   = chose_train(call_actions: false)
  end
  # train.allocate_to(station)
end

# 
# for private / protected
# 

def create_object(collection, repeteable_tip, inspect_methods, loop_options = {})
  gets_loop(repeteable_tip, loop_options) do |recieved|
  	object = yield(recieved)
    collection << object

    inspects = [*inspect_methods].inject([]) { |c, m| c << "#{m}: #{object.send(m)}"}
    print "#{MESSAGES[:created]} #{object.class}; #{inspects * ', '}"
  end
  object
end



def chose_object(collection, name_method, repeteable_tip)
  titles   = collection.map(&name_method) # method, that returns name of each object
  messages_proc = get_messages_proc(titles, repeteable_tip)

  gets_loop(messages_proc, get_index: true, loop: false) do |index|
    object = collection[index - 1]
    yield(object) if block_given?
  end
  object
end



# chose and send method from list
def chose_action(methods_list, *args)
  (methods_list.size == 1) && send(methods_list.first, *args)

  gets_loop(actions_msg_proc, get_index: true) do |index|
    send(methods_list[index - 1], *args)
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
    case (gets_input = gets.chomp.stripe).empty? ? nil : gets_input
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
def get_messages_proc(list, message)
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
    puts message + MESSAGES[:exit_tip]
  when Proc
    message.call
  end
end



5.times  { @trains << Train.new(1000 + rand(8999)) }
alphabet = (?A..?Z).to_a.shuffle
10.times { @stations << Trailroad::Station.new("Station-#{alphabet.shift * 2}") }

main_menu
