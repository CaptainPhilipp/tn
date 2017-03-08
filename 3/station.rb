module Trailroad
  # + Имеет название, которое указывается при ее создании
  # + Может принимать поезда (по одному за раз)
  # + Может показывать список всех поездов на станции, находящиеся в текущий момент
  # + Может показывать список поездов на станции по типу (см. ниже): кол-во грузовых, пассажирских
  # + Может отправлять поезда (по одному за раз, при этом, поезд удаляется из списка поездов, находящихся на станции).
  class Station
    attr_reader :trains, :name

    def initialize(name)
      @name = name
      @trains = []
    end

    def train_incoming(train)
      raise "Wrong argument" unless train.is_a? Train
      @trains << train
    end

    alias new_train train_incoming # как полагается удобнее располагать алиасы?

    def train_departure(train)
      raise "Wrong argument" unless train.nil? || train.is_a?(Train)
      train ? @trains.delete(train) : @trains.shift
    end

    alias remove_train train_departure

    TrainsList = Struct.new :trains, :count
    # список поездов на станции по типу: кол-во грузовых, пассажирских
    def trains_by_type(type)
      list = TrainsList.new [], 0
      @trains.select{ |t| t.type == type }.each do |train|
        list[:trains] << train
        list[:count]  += 1
      end
    end
  end # Station
end
