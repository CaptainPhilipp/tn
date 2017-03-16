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

app = Interface.new

app.seed trains: 15, stations: 10, wagons: 30, num_length: 5

app.main_menu
