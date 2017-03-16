module Interface
  module TrainMenu
    TRAIN_TYPES = %w(CargoTrain PassengerTrain).freeze
    TRAIN_CLASSES = TRAIN_TYPES.map { |type| Object.const_get type }.freeze

    class << self
      def create_train
        return unless train_class = gets_choose_train_type
        puts "\nВведите номер поезда, и опционально, его максимальную скорость"
        return unless split = Gets.splited

        t = train_class.new(*split)
        print "\n Создан #{t.class}##{t.number}, max speed: #{t.max_speed}"
      rescue InvalidData => ex
        puts ex.inspect
        retry
      end

      def select_train(trains = Train.all)
        loop do
          puts "\nВведите id поезда"
          Output.indexed_list(trains, :number, :class, :wagons_count, :location)
          return unless train = Gets.object(trains)
          action_train(train)
        end
      end

      def action_train(train)
        methods_list = %w(select_wagon add_wagons remove_wagon allocate_train)
        puts '   Выберите действие для поезда'
        show_train(train)
        loop do
          Output.indexed_list(methods_list)
          return unless index = Gets.index(max_index: methods_list.size)

          meth = methods_list[index]
          puts "\nВыбран: #{meth}"
          send(meth, train)
        end
      end

      def select_wagon(train)
        WagonMenu.select_wagon(train)
      end

      def add_wagons(train)
        WagonMenu.add_wagons(train)
      end

      def remove_wagon(train)
        WagonMenu.remove_wagon(train)
      end

      def allocate_train(train)
        puts "\nРазместить поезд"
        Output.indexed_list(Station.all, :name, :trains_count)
        return unless station = Gets.object(Station.all)

        train.allocate(station)
        puts "#{train.class}##{train.number} moved to #{station.name}"
      end

      private

      def gets_choose_train_type
        puts "\nВыберите тип поезда"
        Output.indexed_list(TRAIN_TYPES)
        return unless index = Gets.index(max_index: TRAIN_TYPES.size)
        TRAIN_CLASSES[index]
      end

      def show_train(train)
        puts "\nИнформация о поезде"
        puts "\n Number: `#{train.number}`, type: `#{train.class}`, " \
             "max_speed: `#{train.max_speed}` wagons: `#{train.wagons.size}`" \
             "location: `#{train.current_station.name}`"
      end
    end # class << self
  end
end
