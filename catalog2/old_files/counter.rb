letters = ["a","b","c","d","e","f",'g','h','i','j','k','l','m','n','o','p','q','r','s','t','u','v','w','x','y','z']

i = 0
j = 0
k = 5
while k <= letters.length + 5
	while i >= j && i < k
		puts letters[i]
		i += 1
	end
	puts "press a key"
	key = gets.chomp
	key.scan(/./)
		k += 5
end
