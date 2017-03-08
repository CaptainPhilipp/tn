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
    include Trailroad::TrainRoute
    getter :number, :type, :wagons, :speed, :route, :current_station
    # можно ли дублировать метод геттер в модуль? не приходилось никогда
    #
    # То есть можно ли перенести, например, 'getter :route, :current_station'
    # в другой модуль, тут удалив лишнее имена методов?
    # это выглядит логично и удобно, но можно ли?

    def initialize(number, train_type, wagons, max_speed = 120)
      @number    = number
      @type      = train_type
      @wagons    = wagons
      @max_speed = max_speed

      @speed = 0
    end

    def speed_up(amount = 1)
      speed, amount = speed.abs, amount.abs # в такой ситуации мульти можно?
      if @reverse # если движение назад
        @speed -= (speed + amount < @max_speed) ? @max_speed / -4 : amount
      else
        @speed += (speed + amount > @max_speed) ? @max_speed : amount
      end
    end

    def slow_down(amount = 1)
      speed, amount = speed.abs, amount.abs # в такой ситуации мульти можно?
      if @reverse # если движение назад
        @speed += (speed - amount > 0) ? 0 : amount
      else
        @speed -= (speed - amount < 0) ? 0 : amount
      end
    end

    def brake
      @speed = 0
    end

    def switch_reverse
      return false unless stop?
      @reverse = @reserse ? false : true
      true
    end

    def add_wagon
      return false unless stop?
      @wagons += 1
    end

    def remove_wagon
      return false unless stop?
      @wagons -= 1
    end

    private

    def stop?
      @speed.zero?
    end
  end # Station
end
