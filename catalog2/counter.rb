puts "\e[H\e[2J"

arr = ['a','b','c','d','e','f','g','h','i','j','k','l','m','n','o','p','q','r','s','t','u','v','w','x','y','z']

i = 0
k = 5

while i >= 0 && i <= arr.length
	while i < k && k
		puts "#{i + 1}\t#{arr[i]}"
#		puts arr[i]
		i += 1
	end

	key = gets.chomp
	if key == "f"
		k += 5
	elsif key == "b"
		i = i - 10
		k = k - 5
	end

	puts "\e[H\e[2J"

end
