module Trailroad
  module TrainRoute
    def route=(route)
      raise "Wrong argument" unless route.is_a? Route
      @route = route
      @current_station = route.departure
      @current_station_id = 0
    end

    def all_stations
      route.all_stations
    end

    def next_station
      all_stations[current_station_id + 1]
    end

    def prev_station
      all_stations[current_station_id - 1]
    end

    def leave_station
      current_station.train_departure self
      # менять @current_station не буду, ибо сейчас особо незачем,
      # а спорные моменты создаст
    end

    def arrived_to(station)
      station = all_stations[station_id] if station.is_a? Integer
      station.train_incoming self
    end

    # перемещение моментально
    def go_to_station(station_id)
      leave_station
      arrived_to station_id

      @current_station_id = station_id
      @current_station    = all_stations[station_id]
    end

    def go_to_next_station
      go_to_station current_station_id + 1
    end

    def go_to_prev_station
      go_to_station current_station_id - 1
    end
  end
end
