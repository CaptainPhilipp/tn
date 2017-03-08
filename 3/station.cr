module Trailroad
  # + Имеет название, которое указывается при ее создании
  # + Может принимать поезда (по одному за раз)
  # + Может показывать список всех поездов на станции, находящиеся в текущий момент
  # + Может показывать список поездов на станции по типу (см. ниже): кол-во грузовых, пассажирских
  # + Может отправлять поезда (по одному за раз, при этом, поезд удаляется из списка поездов, находящихся на станции).
  class Station
    getter :trains, :name

    def initialize(name)
      @name = name
      @trains = []
    end

    def train_incoming(train)
      raise "Wrong argument" unless train.is_a? Train
      @trains << train
    end

    alias new_train train_incoming # как полагается удобнее располагать алиасы?

    def train_departure(train = nil)
      raise "Wrong argument" unless train.nil? || train.is_a?(Train)
      train ? @trains_delete(train) : @trains.shift
    end

    alias remove_train train_departure

    # список поездов на станции по типу: кол-во грузовых, пассажирских
    # returns {type: [{trains: [], count: Integer}]}
    def trains_by_type
      list = {}
      @trains.each do |train|
        list[train.type] ||= {trains: [], count: 0}
        list[train.type][:trains] << train
        list[train.type][:count]  += 1
      end
      list
    end
  end # Station
end
