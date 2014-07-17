i = 1

while i < 10
	puts i

	key = gets.chomp
	if key == "f"
		i += 1
	elsif key == "b"
		i -= 1
	end
end
