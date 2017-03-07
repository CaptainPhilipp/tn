#
# Квадратное уравнение.
#
# Пользователь вводит 3 коэффициента a, b и с.
# Программа вычисляет дискриминант (D) и корни уравнения (x1 и x2, если они есть)
# и выводит значения дискриминанта и корней на экран.

puts "Введите три коэфициента (a, b и c) через пробел"
split = gets.chomp

raise "Только цифры и пробелы!" unless split =~ /^[0-9\s\.\,]+$/i
split = split.split(' ').map { |x| x.gsub(/\,/, ?.).to_f }
raise "Только три коэффициента!" unless split.size == 3
raise "'a' не должно быть равно 0" if split.first.zero?

a, b, c = *split
d = b**2 - 4 * a * c
equation_roots = ->(meth) { (-b.send(meth, Math.sqrt(d))) / (2 * a) }

roots = []
roots << equation_roots.call(:+) if d >= 0
roots << equation_roots.call(:-) if d >  0

root_msgs = ["корень: ", "корни: ", "корней нет"]
msg = root_msgs[d<=>0]
puts "Дискриминант: #{d}, #{msg}#{roots * ' и '}."
