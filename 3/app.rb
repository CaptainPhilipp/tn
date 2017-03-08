require_relative 'route'
require_relative 'station'
require_relative 'train'

stations = []
alphabet = (?A..?Z).to_a.shuffle
10.times { |i| stations << Trailroad::Station.new("Station #{alphabet.shift}") }
# TODO trains by type

departure   = stations.delete(stations.sample)
destination = stations.delete(stations.sample)
some_route = Trailroad::Route.new departure, destination, *stations

train = Trailroad::Train.new 6874, 'cargo', 12, 60

train.route = some_route

print "\n > Station: #{train.current_station.name}"
print "\n > next station: #{train.next_station.name}\n"

print "\n > speed: #{train.speed}\n"
print "\n #speed_up 12"
train.speed_up 12
print "\n > speed: #{train.speed}\n"
print "\n #slow_down 3"
train.slow_down 3
print "\n > speed: #{train.speed}\n"
print "\n #brake"
train.brake
print "\n > speed: #{train.speed}\n"

print "\n #speed_up 100"
train.speed_up 100
print "\n > speed: #{train.speed}\n"
print "\n #slow_down 100"
train.slow_down 100
print "\n > speed: #{train.speed}\n"


print "\n #go_to_next_station"
train.go_to_next_station
print "\n > current station: #{train.current_station.name}"
print "\n > prev station: #{train.prev_station.name}"
print "\n > destination: #{train.route.destination.name}\n"

st = train.current_station
print "\n > station_trains: #{st.trains_by_type('cargo').map(&:number)}\n"

print "\n 15.times #go_to_next_station"
15.times{ train.go_to_next_station }
print "\n > current station: #{train.current_station.name}"



puts
