# Сделать хеш, содеращий месяцы и количество дней в месяце.
# В цикле выводить те месяцы, у которых количество дней ровно 30
require 'date'
# 1
day_counts0 = Hash.new { |h, month| h[month] = Date.new(Time.now.year, month, -1).day }

# 2
# почти без трюков
# и работает лучше чем генератор хэшей, к слову. там есть неудобности.
day_counts1 = {}
(1..12).each { |month| day_counts1[month] = Date.new(Time.now.year, month, -1).day }

# 3
# совсем-совсем без трюков
day_counts2 = {
  1  => 31,
  2  => 28,
  3  => 31,
  4  => 30,
  5  => 31,
  6  => 30,
  7  => 31,
  8  => 31,
  9  => 30,
  10 => 31,
  11 => 30,
  12 => 31
}

#
# Output
#
# 1
(1..12).each     { |month| puts month if day_counts0[month] == 30 }
# 2
day_counts1.each { |month, days_count| puts month if days_count == 30 }
# 3
day_counts2.each { |month, days_count| puts month if days_count == 30 }
