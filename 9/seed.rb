module Seed
  class << self
    def seed(trains: 5, stations: 10, wagons: 8, num_length: 4)
      seed_trains(trains, num_length)
      seed_wagons(wagons, num_length, Train.all)
      seed_stations(stations)
      seed_allocate_trains(Train.all, Station.all)
    end

    private

    def seed_trains(count, num_length)
      classes = Interface::TrainMenu::TRAIN_CLASSES
      count.times { classes[rand 2].new(Train.generate_num(num_length)) }
    end

    def seed_wagons(count, num_length, trains)
      trains.each do |t|
        rand(count).times do
          t.create_wagon(Train.generate_num(num_length), 10 + rand(60))
        end
      end
    end

    def seed_stations(count)
      alphabet = (?A..?Z).to_a.shuffle
      count.times { Station.new("Station-#{alphabet.shift * 2}") }
    end

    def seed_allocate_trains(trains, stations)
      trains.each { |train| train.allocate stations.sample }
    end
  end # class << self
end
