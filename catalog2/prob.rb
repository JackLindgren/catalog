ar = [1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30]

i = 0
k = 5

while i < ar.length
  puts "\e[H\e[2J"
  while i >= 0 && i < k
    puts "#{i} : #{ar[i]}"
    i += 1
  end
  key = gets.chomp
  key.scan(/./)
    k += 5
end

puts "The end!"
