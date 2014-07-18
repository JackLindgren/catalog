# Takes a text file of book data in the format that it comes if you copy and paste from Goodreads
# takes only the lines that have the author and title and creates a new file with "author::title"

raw_data = Array.new
File.open("books.txt").each {|line| raw_data.push(line.chomp)}

book_info = Array.new

i = 0
while i < raw_data.length
	book_info.push(raw_data[i])
	book_info.push(raw_data[i + 1])
	i += 12
end

File.open("book_data.txt", "w") do |f|
#	book_info.each{|x| f.puts x}
	i = 0
	while i < book_info.length
		f.puts "#{book_info[i]}::#{book_info[i+1]}"
		i += 2
	end
end
