# Заполнить массив числами фибоначчи до 100

# 100 итераций
acc = Array.new(2, 1)
100.times { |i| acc << (acc[i] + acc[i + 1]) }
puts acc

# результат менее 100
acc, i = Array.new(2, 1), 0
loop do
  if (num = acc[i] + acc[i + 1]) >= 100
    break
  else
    acc << num
  end
  i += 1
end

puts acc
