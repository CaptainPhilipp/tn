module Trailroad
  # + Имеет номер (произвольная строка) и тип (грузовой, пассажирский) и
  # + количество вагонов, эти данные указываются при создании экземпляра класса
  # + Может набирать скорость
  # + Может показывать текущую скорость
  # + Может тормозить (сбрасывать скорость до нуля)
  # + Может показывать количество вагонов
  # + Может прицеплять/отцеплять вагоны (по одному вагону за операцию,
  # + метод просто увеличивает или уменьшает количество вагонов).
  # + Прицепка/отцепка вагонов может осуществляться только если поезд не движется.
  # + Может принимать маршрут следования (объект класса Route)
  # + Может перемещаться между станциями, указанными в маршруте.
  # + Показывать предыдущую станцию, текущую, следующую, на основе маршрута
  class Train
    getter :number, :type, :wagons, :speed, :route, :current_station

    def initialize(number, train_type, wagons, max_speed = 120)
      @number    = number
      @type      = train_type
      @wagons    = wagons
      @max_speed = max_speed

      @speed = 0
    end

    def speed_up(amount = 1)
      @speed += @speed + amount.abs > @max_speed ? @max_speed : amount.abs
    end

    def slow_down(amount = 1)
      @speed -= @speed - amount.abs < 0 ? 0 : amount.abs
    end

    def brake
      @speed = 0
    end

    def add_wagon
      return false unless stop?
      @wagons += 1
    end

    def remove_wagon
      return false unless stop?
      @wagons -= 1
    end

    def route=(route)
      raise "Wrong argument" unless route.is_a? Route
      @route = route
      @current_station = route.departure
      @current_station_id = 0
    end

    def all_stations
      route.all_stations
    end

    def next_station_id
      @current_station_id + 1
    end

    def prev_station_id
      @current_station_id - 1
    end

    def next_station
      all_stations[next_station_id]
    end

    def prev_station
      all_stations[prev_station_id]
    end

    # перемещение моментально
    def go_to_station(station_id)
      current_station.train_departure self
      all_stations[station_id].train_incoming self

      @current_station_id = station_id
      @current_station    = all_stations[station_id]
    end

    def go_to_next_station
      go_to_station next_station_id
    end

    def go_to_prev_station
      go_to_station prev_station_id
    end

    private

    def stop?
      @speed.zero?
    end
  end # Station
end
