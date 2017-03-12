# Заполнить хеш гласными буквами,
# где значением будет являтся порядковый номер буквы в алфавите (a - 1).
alphabet = ('a'..'z').to_a
vovels = {}
alphabet.each_with_index { |letter, i| vovels[letter] = i + 1 }
puts vovels
