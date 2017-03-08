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
    attr_reader :number, :type, :wagons, :speed, :route, :current_station

    def initialize(number, train_type, wagons, max_speed = 120)
      @number    = number
      @type      = train_type
      @wagons    = wagons
      @max_speed = max_speed

      @speed = 0
    end

    def speed_up(amount = 1)
      speed, amount = @speed.abs, amount.abs
      @speed = (speed + amount > @max_speed) ? @max_speed : @speed + amount
    end

    def slow_down(amount = 1)
      speed, amount = @speed.abs, amount.abs
      @speed = (speed - amount < 0) ? 0 : @speed - amount
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

    #
    # Route's & Station's
    #

    def route=(route)
      raise "Wrong argument" unless route.is_a? Route
      @route = route
      @current_station = route.departure
      @current_station_id = 0
    end

    def next_station
      route.all_stations[@current_station_id + 1]
    end

    def prev_station
      route.all_stations[@current_station_id - 1]
    end

    def leave_station
      current_station.train_departure self
      # менять @current_station не буду, ибо сейчас особо незачем,
      # а спорные моменты создаст
    end

    def arrived_to(station)
      station = route.all_stations[station] if station.is_a? Integer
      station.train_incoming self
    end

    # перемещение моментально
    def go_to_station(station_id)
      leave_station
      arrived_to station_id

      @current_station_id = station_id
      @current_station    = route.all_stations[station_id]
    end

    def go_to_next_station
      return false if @current_station_id == route.all_stations.size - 1
      go_to_station @current_station_id + 1
    end

    def go_to_prev_station
      return false if @current_station_id.zero?
      go_to_station @current_station_id - 1
    end

    private

    def stop?
      @speed.zero?
    end
  end # Station
end
