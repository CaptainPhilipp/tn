module Interface
  module WagonMenu
    class << self
      def add_wagons(train)
        puts "\nВведите номер и вместительность вагона"
        return unless split = Gets.splited
        wagon = train.create_wagon(*split)
        Output.wagon_changes(:added, wagon, train)
      rescue InvalidData => ex
        puts ex.inspect
        retry
      end

      def select_wagon(train)
        info_methods = [:number, :class, :available_space, :filled_space]
        Output.indexed_list(train.wagons, *info_methods)
        return unless index = Gets.index(max_index: train.wagons.size)
        action_wagon(train.wagons[index])
      end

      def action_wagon(wagon)
        methods_list = %w(load_wagon unload_wagon)
        puts '   Выберите действие для вагона'
        show_wagon(wagon)
        loop do
          Output.indexed_list(methods_list)
          return unless index = Gets.index(max_index: methods_list.size)
          meth = methods_list[index]
          puts "\nВыбран: #{meth}"
          send(meth, wagon)
        end
      end

      def load_wagon(wagon)
        puts "\n Введите количество"
        return unless integer = Gets.integer
        amount = wagon.fill_space(integer)
        Output.wagon_capacity_changes(:load, wagon, amount)
      end

      def unload_wagon(wagon)
        puts "\n Введите количество"
        return unless integer = Gets.integer
        amount = wagon.release_space(integer)
        Output.wagon_capacity_changes(:unload, wagon, amount)
      end

      def remove_wagon(train)
        return if train.wagons.size.zero?
        wagons = train.remove_wagon
        Output.wagon_changes(:removed, wagons.first, train)
      end

      def show_wagon(wagon)
        puts "\nИнформация о вагоне"
        puts "\n Number: `#{wagon.number}`, type: `#{wagon.class}`, " \
             "available_space: `#{wagon.available_space}`" \
             "filled_space: `#{wagon.filled_space}`"
      end
    end # class << self
  end
end
