# Заданы три числа, которые обозначают число, месяц, год (запрашиваем у пользователя).
# Найти порядковый номер даты, начиная отсчет с начала года.
# Учесть, что год может быть високосным.
# (Запрещено использовать встроенные в ruby методы для этого
# вроде Date#yday или Date#leap?)
# Алгоритм опредления високосного года: www.adm.yar.ru

def leap?(year)
  year % 4 == 0 && (year % 100 != 0 || year % 400 == 0)
end

def days_in_month(month, year)
  counts = [0, 31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31] # 0 что бы убрать лишний if

  counts[month] + ( month == 2 && leap?(year) ? 1 : 0 )
end

puts "Введите число, месяц, год"
answer = gets.chomp.split(' ').map(&:to_i)
raise "не-а" unless answer.size == 3
day, month, year = answer
raise "wrong month" unless (1..12).include? month
raise "wrong day"   unless (1..days_in_month(month, year)).include? day

dayscount = day
(1..month).each do |month|
  previous_month = month - 1
  dayscount += days_in_month(previous_month, year)
end

puts dayscount
