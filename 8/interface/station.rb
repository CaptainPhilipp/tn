module Interface
  module StationMenu
    class << self
      def create_station
        puts "\nВведите имя станции"
        return unless name = Gets.nilable
        Station.new(name)
        puts "\n Создана станция #{name}"
      rescue InvalidData => ex
        puts ex.inspect
        retry
      end

      def select_station
        loop do
          puts "\nВведите id станции"
          Output.indexed_list(Station.all, :name, :trains_count)
          return unless station = Gets.object(Station.all)
          select_station_trains(station)
        end
      end

      private

      def select_station_trains(station)
        puts "\nПоезда на станции #{station.name}: "
        on_station = Train.all.select { |t| t.current_station == station }
        if on_station.empty?
          puts "\nПоездов нет."
          return
        end
        Interface.select_train(on_station)
      end
    end # class << self
  end
end
