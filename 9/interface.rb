require_relative 'gets'
require_relative 'output'

require_relative 'interface/wagon'
require_relative 'interface/train'
require_relative 'interface/station'

class InvalidData < RuntimeError; end

module Interface
  class << self
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
      StationMenu.create_station
    end

    def create_train
      TrainMenu.create_train
    end

    def select_station
      StationMenu.select_station
    end

    def select_train(trains = Train.all)
      TrainMenu.select_train(trains)
    end
  end # class << self
end
