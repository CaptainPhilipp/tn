require 'date'

# Заданы три числа, которые обозначают число, месяц, год (запрашиваем у пользователя).
# Найти порядковый номер даты, начиная отсчет с начала года.
# Учесть, что год может быть високосным.
# (Запрещено использовать встроенные в ruby методы для этого
# вроде Date#yday или Date#leap?)
# Алгоритм опредления високосного года: www.adm.yar.ru

puts "Введите число, месяц, год"
answer = gets.chomp.split(' ').map(&:to_f)
raise "не-а" unless answer.size == 3
day, month, year = answer
raise "wrong date" unless (0..31).include?(day) || (1..12).include?(month)

leap = year % 4 == 0 && (year % 100 != 0 || year % 400 == 0)
days_in = Hash.new do |h, m| # days_in[month]
 h[m] = 28 + (m + (m / 8).floor) % 2 + 2 % m + 2 * (1 / m).floor
 h[m] += 1 if m == 2 if leap
end

days_in[month]
current_days = days_in[month]
raise "wrong day" if day > current_days

at_end = (0..month).to_a.inject { |memo, m| days_in[m]; memo + days_in[m] }

puts (at_end - (current_days - day)).to_i
