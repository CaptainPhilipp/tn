# Сделать хеш, содеращий месяцы и количество дней в месяце.
# В цикле выводить те месяцы, у которых количество дней ровно 30
require 'date'
days = Hash.new { |h, month| h[month] = Date.new(Time.now.year, month, -1).day }
(1..12).each { |month| puts month if days[month] == 30 }
