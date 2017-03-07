# Заполнить массив числами фибоначчи до 100

# 100 итераций
acc = [1, 1]
100.times { acc << (acc[-1] + acc[-2]) }
puts acc

# результат менее 100
acc = [1, 1]
while (num = acc[-1] + acc[-2]) < 100
  acc << num
end

puts acc
