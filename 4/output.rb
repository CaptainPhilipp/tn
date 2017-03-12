class Output
  # показывает элементы коллекции построчно
  # дополняет строку, вызывая к ним инфометоды на каждой строке,
  # представляет в виде ровной таблички
  def self.indexed_list(collection, *info_methods)
    rows = []
    collection.each_with_index do |item, i|
      row = [" [#{i + 1}] "]
      info_methods.each { |method| row << "#{method}: `#{item.send(method)}`" }
      row.insert(1, item) if row.size == 1 && item.is_a?(String)
      rows << row
    end
    max_len = max_length_of_columns(rows)
    puts rows.map { |a| a.map.with_index { |s, i| s.ljust max_len[i] } * ' ' }
  end

  private

  # считает максимальную длину каждого столбца
  def self.max_length_of_columns(rows)
    max_len = []
    columns_count = rows.first.size
    columns_count.times do |c|
      column = []
      rows.size.times { |r| column << rows[r][c] }
      max_len << column.inject(1) { |memo, row| [row.size, memo].max }
    end
    max_len
  end
end
