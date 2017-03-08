module Trailroad
  # + Имеет начальную и конечную станцию, а также список промежуточных станций.
  # + Начальная и конечная станции указываютсся при создании маршрута, а промежуточные могут добавляться между ними.
  # + Может добавлять промежуточную станцию в список
  # + Может удалять промежуточную станцию из списка
  # + Может выводить список всех станций по-порядку от начальной до конечной
  class Route
    getter :departure, :stations, :destination

    def initialize(departure, destination, *stations)
      [departure, destination, *stations].each { |s| raise unless s.is_a? Station }

      @departure   = departure
      @destination = destination
      @stations    = stations
    end

    def add_station(new_station, position = nil)
      @all_stations_memo = nil
      position ? @stations[position, 0] = new_station : @stations << new_station
    end

    def remove_station(rm_station = nil)
      @all_stations_memo = nil
      case
      when rm_station.is_a? Integer then @station.delete_at rm_station
      when rm_station.is_a? Station then @station.delete    rm_station
      when rm_station.nil?          then @stations.shift
      else raise "Wrong argument"
      end
    end

    def all_stations
      @all_stations_memo ||= [@departure, *@stations, @destination]
    end
  end # Route
end
