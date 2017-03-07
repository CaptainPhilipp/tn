puts 'Представьтесь пожалуйста'
name = gets.chomp.split(' ').map(&:capitalize) * ' '

puts 'Введите Ваш рост'
raise 'Смешно, да' if (height = gets.chomp.to_i) <= 0
ideal_weight = height - 110

puts "#{name}, Ваш #{ideal_weight <= 0 ? 'вес идеален!' : "идеальный вес: #{ideal_weight} кг"}"
