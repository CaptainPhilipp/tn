# Заданы три числа, которые обозначают число, месяц, год (запрашиваем у пользователя).
# Найти порядковый номер даты, начиная отсчет с начала года.
# Учесть, что год может быть високосным.
# (Запрещено использовать встроенные в ruby методы для этого
# вроде Date#yday или Date#leap?)
# Алгоритм опредления високосного года: www.adm.yar.ru

DAYCOUNTS = [0, 31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31] # 0 - нулябрь. вроде так иногда делают?

def leap?(year)
  year % 4 == 0 && (year % 100 != 0 || year % 400 == 0)
end

puts "Введите число, месяц, год"
answer = gets.chomp.split(' ').map(&:to_i)
raise "не-а" unless answer.size == 3
day, month, year = answer
raise "wrong month" unless (1..12).include? month

dayscount = ->(monh = month) { DAYCOUNTS[monh] + ( monh == 2 && leap?(year) ? 1 : 0 ) }

raise "wrong day" unless (1..dayscount.call).include? day

count = day
(1..month).each do |month|
  previous_month = month - 1
  count += dayscount.call(previous_month)
end

puts count
