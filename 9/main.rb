require_relative 'accessors'
require_relative 'validation'

require_relative 'instance_counter'
require_relative 'manufacture'

require_relative 'station'
require_relative 'train'
require_relative 'wagon'

require_relative 'cargo_train'
require_relative 'passenger_train'
require_relative 'cargo_wagon'
require_relative 'passenger_wagon'

require_relative 'interface'
require_relative 'seed'

Seed.seed trains: 15, stations: 10, wagons: 30, num_length: 5
puts "\nSeed"
puts "CargoTrain.instances:         #{CargoTrain.instances}"
puts "CargoTrain.instances_history: #{CargoTrain.instances_history}"

Interface.main_menu
