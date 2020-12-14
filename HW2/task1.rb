# frozen_string_literal: true

array = [621, 445, 147, 159, 430, 222, 482, 44, 194, 522, 652, 494, 14,
         126, 532, 387, 441, 471, 337, 446, 18, 36, 202, 574, 556, 458,
         16, 139, 222, 220, 107, 82, 264, 366, 501, 319, 314, 430, 55, 336]

p '1. Узнать количество элементов в массиве'
p array.count
p '________________________________________'

p '2. Узнать количество элементов в массиве'
p array.reverse
p '________________________________________'

p '3. Найти наибольшее число'
p array.max
p '________________________________________'

p '4. Найти наименьшее число'
p array.min
p '________________________________________'

p '5. Отсортировать от меньшего к большему'
p array.sort
p '________________________________________'

p '6. Oтсортировать от большего к меньшему'
p array.sort { |a, b| b <=> a }
p '________________________________________'

p '7. Удалить все нечетные числа'
arr = array.dup
p arr.delete_if(&:odd?)
p '________________________________________'

p '8. Oставить только те числа, которые без остатка делятся на 3'
p array.select { |num| (num % 3).zero? }
p '________________________________________'

p '9. Удалить из массива числа, которые повторяются (то есть, нужно вывести массив, в котором нет повторов'
p array.uniq
p '________________________________________'

p '10. Pазделить каждый элемент на 10, в результате элементы не должны быть округлены до целого'
p array.map { |num| num.to_f / 10 }
p '________________________________________'

p '11. Получить новый массив, который бы содержал в себе те буквы английского алфавита, порядковый номер которых есть в нашем массиве'
d = ('a'..'z').to_a
p d.each_with_index.map { |key, num| key if array.include?(num + 1) }.compact
p '________________________________________'

p '12. Поменять местами минимальный и максимальный элементы массива'
min = array.index(array.min)
max = array.index(array.max)
array[min] = array.max
array[max] = array.min
p array
p '________________________________________'

p '13. Найти элементы, которые находятся перед минимальным числом в массиве'
p array.take(array.index(array.min))
p '________________________________________'

p '14. Необходимо найти три наименьших элемента'
p array.min(3)
p '________________________________________'