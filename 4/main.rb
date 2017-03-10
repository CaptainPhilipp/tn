require          '../3/route'
require          '../3/station'
require_relative 'train'
require_relative 'cargo_train'
require_relative 'passenger_train'
require_relative 'wagon'
require_relative 'cargo_wagon'
require_relative 'passenger_wagon'

#  - Добавлять вагоны к поезду
#  - Отцеплять вагоны от поезда
#  - Помещать поезда на станцию
#  - Просматривать список станций и список поездов на станции

ABORT_KEYS = ['q', 'й', nil]


# глобальные временно, пока не выделил в класс
$trains   = []
$stations = []



def main_menu
  methods = %w[chose_station chose_train create_station create_train]
  messages = get_messages_proc(methods, 'Введите номер комманды для её вызова')

  puts 'Главное меню'

  gets_loop(messages) do |recieved|
   index  = recieved.split(' ').first.to_i
   method = methods[index - 1]
   send method
  end
end



def create_station
  puts '- Создать станцию'
  message = 'Введите имя станции'
  gets_loop(message) do |recieved_name|
    station = Trailroad::Station.new recieved_name

    $stations << station

    puts ">> Создана станция '#{station.name}'"
  end
end



def create_train
  puts '- Создать поезд'
  message = 'Введите номер поезда, и опционально, его максимальную скорость'
  gets_loop(message) do |recieved|
    args = recieved.split(' ').map(&:to_i)

    train = Train.new *args
    $trains << train

    puts ">> Создан поезд #{train.number}, " +
            "максимальная скорость: #{train.max_speed}"
  end
end



def chose_train
  train_numbers    = $trains.map &:number
  trains_msg_proc  = get_messages_proc(train_numbers, 'Введите id поезда')
  actions_msg_proc = get_messages_proc(methods, 'Введите номер комманды для её вызова')

  gets_loop(trains_msg_proc) do |recieved|
   index, *args = recieved.split(' ')
   train = $trains[index.to_i - 1]

   chose_train_action
  end
end



def chose_train_action
  methods = %w[add_wagons remove_wagons allocate_train]
  
  gets_loop(actions_msg_proc) do |recieved|
    index = recieved.split(' ').first.to_i - 1
    send(methods[index], train, *args)
   end
end



def add_wagons(train)
  wagon = train.add_wagon
  puts "#{wagon.class} added to the #{train.class}"
  puts "#{train.class} number #{train.number} have #{train.wagons.size} wagons"
end



def remove_wagons(train)
  train.remove_wagon
  puts "#{wagon.class} removed to the #{train.class}"
  puts "#{train.class} number #{train.number} have #{train.wagons.size} wagons"
end



def allocate_train(train_or_station)
  case train_or_station
  when Train
    #
  when Station
    #
  end
end



def chose_station
  station_names = $stations.map &:name
  stations_msg_proc = get_messages_proc(station_names, 'Введите id станции')

  gets_loop(stations_msg_proc) do |recieved|
   index = recieved.split(' ').first.to_i
   station = $stations[index - 1]
  #  allocate_train
  end
end



def gets_string
  (recieved = gets.chomp).empty? ? nil : recieved
end



# loop while gets
def gets_loop(message)
  loop do
    print_inloop_message(message)

    case recieved = gets_string
    when *ABORT_KEYS
      print " # Отмена\n\n"
      break
    else
      result = yield recieved
    end
  end
end


def get_messages_proc(list, message)
  ->{
      puts message
      list.each_with_index { |item, i| puts " [#{i + 1}] #{item}" }
    }
end



def print_inloop_message(message)
  case message
  when String
    puts message + exit_reminder_string
  when Proc
    message.call
  end
end



def exit_reminder_string
  ''
  # "   [для выхода `#{ABORT_KEYS.first}` или Enter]\n\n"
end

5.times { $trains << Train.new(1000 + rand(8999)) }
alphabet = (?A..?Z).to_a.shuffle
5.times { $stations << Trailroad::Station.new("Station-#{alphabet.shift * 2}") }

main_menu
