module Output
  class << self
    # показывает элементы коллекции построчно
    # дополняет строку, вызывая к ним инфометоды на каждой строке,
    # представляет в виде ровной таблички
    def indexed_list(collection, *info_methods)
      rows    = build_rows(collection, *info_methods)
      max_len = max_length_of_columns(rows)
      puts rows.map { |a| a.map.with_index { |s, i| s.ljust max_len[i] } * ' ' }
    end

    def wagon_changes(action, wagon, train)
      event = { added: 'added to', removed: 'removed from' }[action]
      puts "#{wagon.class} with capacity #{wagon.capacity}" \
           "#{event} the #{train.class}"
      puts "#{train.class} number #{train.number}" \
           "have #{train.wagons.size} wagons"
    end

    def wagon_capacity_changes(action, wagon, amount)
      case wagon
      when CargoWagon
        event = { load: 'loaded', unload: 'unloaded' }[action]
        puts "\nWagon #{event} by #{amount}. " \
        "available: #{wagon.available_space}, filled: #{wagon.filled_space}"
      when PassengerWagon
        event = { load: 'boarded', unload: 'leave' }[action]
        puts "\n#{amount} passengers #{event} wagon. " \
        "free: #{wagon.available_space}, passengers: #{wagon.filled_space}"
      end
    end

    private

    def build_rows(collection, *info_methods)
      rows = []
      collection.each_with_index do |item, i|
        row = [" [#{i + 1}] "]
        info_methods.each { |meth| row << "#{meth}: `#{item.send(meth)}`" }
        row.insert(1, item) if row.size == 1 && item.is_a?(String)
        rows << row
      end
      rows
    end

    # считает максимальную длину каждого столбца
    def max_length_of_columns(rows)
      max_len = []
      columns_count = rows.first.size
      columns_count.times do |c|
        column = []
        rows.size.times { |r| column << rows[r][c] }
        max_len << column.inject(1) { |memo, row| [row.size, memo].max }
      end
      max_len
    end
  end # self
end
