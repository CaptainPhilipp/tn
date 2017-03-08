module Trailroad
  # + Имеет начальную и конечную станцию, а также список промежуточных станций.
  # + Начальная и конечная станции указываютсся при создании маршрута, а промежуточные могут добавляться между ними.
  # + Может добавлять промежуточную станцию в список
  # + Может удалять промежуточную станцию из списка
  # + Может выводить список всех станций по-порядку от начальной до конечной
  class Route
    attr_reader :stations

    def initialize(*stations)
      raise unless stations.all? { |s| s.is_a? Station }
      @stations = stations
    end

    def add_station(position = -2, *new_stations)
      @stations.insert position, *new_stations
    end

    def remove_station(rm_station = nil)
      case
      when Integer then @station.delete_at rm_station
      when Station then @station.delete    rm_station # TODO удалять по name, а не object_id
      when Nil     then @stations.shift
      else raise "Wrong argument"
      end
    end
  end # Route
end
