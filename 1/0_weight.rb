#
# Идеальный вес.
#
# Программа запрашивает у пользователя имя и рост
# и выводит идеальный вес по формуле <рост> - 110,
# после чего выводит результат пользователю на экран с обращением по имени.
# Если идеальный вес получается отрицательным, то выводится строка "Ваш вес уже оптимальный"
puts 'Представьтесь пожалуйста'
username = gets.chomp.split(' ').map(&:capitalize) * ' '

height = 0
loop do
  puts 'Сообщите Ваш рост'
  height = gets.chomp.to_i
  break unless height.zero?
  puts 'Укажите реальный рост цифрами'
end

ideal_weight = height - 110

message = ideal_weight <= 0 ? 'вес идеален!' : "идеальный вес: #{ideal_weight} кг"
puts "#{username}, Ваш #{message}"