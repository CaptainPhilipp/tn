puts "Введите основание и высоту треугольника через пробел"
line = gets.chomp.split(' ').map(&:to_f).reject(&:zero?)
raise "Неверный формат" unless line.size == 2

puts "Площадь треугольника с основанием #{line[0]} и высотой #{line[1]}, равна #{0.5 * a * h}"
