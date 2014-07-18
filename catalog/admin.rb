require 'rubygems'
require 'sqlite3'
$db = SQLite3::Database.new("lib_catalog")
$db.results_as_hash = true

def view_all(option)
	#This is basically where the most stuff happens
	puts "\e[H\e[2J"

	#consolidated the view, update, and delete functions into one place
	if option == "v"
		mode = "viewing"
	elsif option == "u"
		mode = "updating"
	elsif option == "d"
		mode = "deletion"
	end

	all_books = Array.new
	$db.execute("SELECT * FROM books").each do |n|
		book = n
		all_books.push("\t%-30s %-45s %-6s %-15s %-15s %-20s %-4s" % [book['author'][0..28], book['title'][0..42], book['year'], book['country'], book['language'], book['subject'], book['id']])
	end

	all_books.sort!

	i = 0
	k = 15
	while i < all_books.length
		puts"\e[H\e[2J"
		puts "currently in #{mode} mode"
		puts "\t\t%-30s %-45s %-6s %-15s %-15s %-20s" % ["Author", "Title", "Year", "Country", "Language", "Subject"]
		puts "\n"
		while i >= 0  && i < k && i < all_books.length
			puts "\t#{i+1}  #{all_books[i][0..133]}"
			i += 1
		end
		puts "press 'F' to move forward 'B' to move back and 'q' to go home"
		if option == "u"
			puts "enter the number of the record you would like to edit"
		elsif option == "d"
			puts "enter the number of the record you would like to delete"
		end

		key = gets.chomp
		if key == "f" || key == "F" || key == ""
			k += 15
		elsif key == "b" || key == "B"
			i = i - 30
			k = k - 15
		elsif key == "q" || key == "Q"
			homescreen
		elsif key.to_i > 0 && option == "u"
			call_record(all_books[key.to_i - 1][-4..-1].to_i)
			edit_record(all_books[key.to_i - 1][-4..-1].to_i)
			break
		elsif key.to_i > 0 && option == "d"
			call_record(all_books[key.to_i - 1][-4..-1].to_i)
			puts "Are you SURE you want to delete this record? (y/n)"
			sure = gets.chomp
			if sure == "y" || sure == "Y"
				puts "the record for this book will be permanently deleted from the database."
				puts "continue? (y/n)"
				positive = gets.chomp
				if positive == "y" || positive == "Y"
					$db.execute("DELETE FROM books WHERE id = ?", "#{all_books[key.to_i - 1][-4..-1].to_i}")
					puts "Record deleted"
					get_back
				else
					get_back
				end
			else
				get_back
			end
		end
	end
	get_back
end

def edit_field
	puts "\e[H\e[2J"
	puts "Which field would you like to edit?"
	puts "c = country"
	puts "l = language"
	puts "s = subject"
	puts "a = author"
	puts "(leave blank to go home)"
	field = gets.chomp
	if field == "c" || field == "C"
		change_field("country")
	elsif field == "l" || field == "L"
		change_field("language")
	elsif field == "s" || field == "S"
		change_field("subject")
	elsif field == "a" || field == "A"
		change_field("author")
	else
		homescreen
	end
end

def change_field(cls)
	puts "here are the options for #{cls}:"
	fields = Array.new
	$db.execute("SELECT DISTINCT #{cls} FROM books").each do |x|
		fields.push( %Q{\t#{x["#{cls}"]}} )
	end

	fields.sort.each{|x| puts x}

	puts "\nEnter the #{cls} to edit"
	puts "Leave blank to go home"
	old_f = gets.chomp
	if old_f == ""
		homescreen
	elsif old_f != ""
		puts "\e[H\e[2J"
		puts "updating #{old_f}"
		puts "Enter the new name"
		new_f = gets.chomp
		puts "The #{cls} field for all records labelled #{old_f} will be changed to #{new_f}"
		puts "Continue? (y/n)"
		choice = gets.chomp
		if choice == "y" || choice == "Y"
			$db.execute("UPDATE books SET #{cls} = ? WHERE #{cls} = ?", new_f, old_f)
		else
			edit_field
		end

		get_back

	else
		homescreen
	end
end

def stats
	#want it to do more here.
	# top 10 authors
	# top 5 countires
	# top 5 languages
	# top 5 decades
	puts "\e[H\e[2J"
	puts "stats screen\n\n"
	puts "\t\t\t\t\tAuthor........#{maxes("author")}"
	puts "\t\t\t\t\tLanguage......#{maxes("language")}"
	puts "\t\t\t\t\tCountry.......#{maxes("country")}"
	puts "\t\t\t\t\tSubject.......#{maxes("subject")}"
	puts "\t\t\t\t\tYear..........#{maxes("year")}"
	puts "\t\t\t\t\tDecade........#{most_decade}"

	puts "For top authors(A); top languages(L); top countries(C); top subjects(S); top decades(D)"
	option = gets.chomp
	if option == "a" || option == "A"
		top_5("author")
	elsif option == "l" || option == "L"
		top_5("language")
	elsif option == "c" || option == "C"
		top_5("country")
	elsif option == "s" || option == "S"
		top_5("subject")
	elsif option == "d" || option == "D"
		puts "option not available yet"
		end

	puts "To go home, enter H"
	puts "To get more stats, use any other key"
	key = gets.chomp
	if key == "h" || key == "H"
		homescreen
	else
		stats
	end
end

def top_5(field)
	result = Array.new
	top5 = Array.new

	$db.execute("SELECT #{field} FROM books").each do |b|
		result.push("#{b["#{field}"]}")
	end

	5.times do
		freq = result.inject(Hash.new(0)) {|h,v| h[v] += 1; h}
		ans = result.max_by {|v| freq[v]}
		top5.push("#{ans} (#{freq[ans]})")
		result.delete(ans)
	end

	i = 0
	while i < top5.length
		puts top5[i]
		i +=1
	end

end


#^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^#
#                                           #
#    stuff up here can use work             #
#                                           #
#############################################
#                                           #
#    happy with how these work right now    #
#                                           #
#vvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvv#

def homescreen
	puts "\e[H\e[2J"
	puts "\n\n\t\t\t\t\tWhat would you like to do?"
	puts "\n\n\t\t\t\t\te = enter a book"
	puts "\n\n\t\t\t\t\ts = setup the database"
	puts "\n\n\t\t\t\t\tu = update a record"
	puts "\n\n\t\t\t\t\td = delete a record"
	puts "\n\n\t\t\t\t\tf = update a field"
	puts "\n\n\t\t\t\t\tv = view all records"
	puts "\n\n\t\t\t\t\ti = view some stats"
	puts "\n\n\t\t\t\t\tp = import a file"
	puts "\n\n\t\t\t\t\tq = quit"
	print "\n\n\t\t\t\t\t"	
	choice = gets.chomp

	if choice == "e" || choice == "E"
		add_book
	elsif choice == "s" || choice == "S"
		create_table
	elsif choice == "u" || choice == "U"
		view_all("u")
	elsif choice == "d" || choice == "D"
		view_all("d")
	elsif choice == "v" || choice == "V"
		view_all("v")
	elsif choice == "f" || choice == "F"
		edit_field
	elsif choice == "p" || choice == "P"
		import
	elsif choice == "q" || choice == "Q"
		disconnect
	elsif choice == "i" || choice == "I"
		stats
	else
		homescreen
	end
end

def maxes(field)
	result = Array.new
	$db.execute("SELECT #{field} FROM books").each do |b|
		result.push("#{b["#{field}"]}")
	end
	freq = result.inject(Hash.new(0)) {|h,v| h[v] += 1; h}
	ans = result.max_by {|v| freq[v]}
	return "#{ans} (#{freq[ans]})"
end

def most_decade
	years = Array.new
	$db.execute("SELECT year FROM books").each do |b|
		years.push("#{b['year']}")
	end
	years.each_index {|x| years[x] = years[x].to_s.chop.to_i}
	freq = years.inject(Hash.new(0)) {|h,v| h[v] += 1; h}
	ans = years.max_by {|v| freq[v]}
	return "#{ans}0s (#{freq[ans]})"
end

def import
	puts "Enter the name of the file you want to import"
	filename = gets.chomp
	File.open("#{filename}", "r").each do |line|
		$db.execute("INSERT INTO books (title, author, subject, language, country) VALUES (?, ?, ?, ?, ?)", line.chomp.split(/::/)[0], line.chomp.split(/::/)[1], line.chomp.split(/::/)[2], line.chomp.split(/::/)[3], line.chomp.split(/::/)[4])
	end

	get_back
end

def get_back
	puts "To return home, press any key"
	key = gets.chomp
	key.scan(/./)
		homescreen
end

def disconnect
	$db.close
	puts "Bye!"
	puts "\e[H\e[2J"
	exit
end

def create_table
	puts "Creating books table"
	$db.execute %q{
		CREATE TABLE books (
		id integer primary key,
		title varchar (50),
		author varchar (50),
		country varchar (20),
		language varchar (20),
		subject varchar (20),
		year integer)
	}
	puts "\e[H\e[2J"
	homescreen
end

def edit_record(id_num)
	puts "\n\n"

	puts "Enter the new title (or leave blank)"
	title = gets.chomp

	work = $db.execute("SELECT * FROM books WHERE id = ?", id_num).first

	if title == ""
		title = work['title']
	end

	puts "Enter the new author (or leave blank)"
	auth = gets.chomp
	if auth == ""
		auth = work['author']
	end

	puts "Enter the new language (or leave blank)"
	language = gets.chomp
	if language == ""
		language = work['language']
	end

	puts "Enter the new country (or leave blank)"
	country = gets.chomp
	if country == ""
		country = work['country']
	end

	puts "Enter the new subject (or leave blank)"
	subject = gets.chomp
	if subject == ""
		subject = work['subject']
	end

	puts "Enter the new year (or leave blank)"
	year = gets.chomp
	if year == ""
		year = work['year'].to_i
	end

	puts "The new records will be:\n"
	puts "Title:.....#{title}"
	puts "Author:....#{auth}"
	puts "Language:..#{language}"
	puts "Country:...#{country}"
	puts "Subject:...#{subject}"
	puts "Year:......#{year}"

	puts "Is this correct? (y/n)"
	puts "Or press 'C' to cancel"
	correct = gets.chomp
	if correct == "y" || correct == "Y"
		$db.execute("UPDATE books SET title = ?, author = ?, language = ?, country = ?, subject = ?, year = ? WHERE id = ?", title, auth, language, country, subject, year.to_i, id_num)
	elsif correct == "c" || correct == "C"
		view_all("u")
	elsif correct == "n" || correct == "N" || correct == ""
		puts "\e[H\e[2J"
		call_record(id_num)
		edit_record(id_num)
	end
	
	puts "To make further edits, press 'C'"
	puts "To return to the list of records, press 'R'"
	puts "To view the new record, press 'V'"
	puts "To return home, press 'H'"
	option = gets.chomp
	if option == 'c' || option == 'C'
		edit_record(id_num)
	elsif option == 'r' || option == 'R'
		view_all("u")
	elsif option == 'v' || option == 'V'
		call_record(id_num)
	elsif option == 'h' || option == 'H'
		homescreen
	end
end


def add_book
	puts "\e[H\e[2J"
	puts "\n\n\t\t\t\t\tEnter the title"
	print "\n\n\t\t\t\t\t"
	title = gets.chomp
	puts "\n\n\t\t\t\t\tEnter the author's name (Last, First)"
	print "\n\n\t\t\t\t\t"
	author = gets.chomp
	puts "\n\n\t\t\t\t\tEnter the country"
	print "\n\n\t\t\t\t\t"
	country = gets.chomp
	puts "\n\n\t\t\t\t\tEnter the language"
	print "\n\n\t\t\t\t\t"
	language = gets.chomp
	puts "\n\n\t\t\t\t\tEnter the subject"
	print "\n\n\t\t\t\t\t"
	subject = gets.chomp
	puts "\n\n\t\t\t\t\tEnter the year of publication"
	print "\n\n\t\t\t\t\t"
	year = gets.chomp.to_i

	$db.execute("INSERT INTO books (title, author, country, language, subject, year) VALUES (?, ?, ?, ?, ?, ?)", title, author, country, language, subject, year)

	get_back
end

def call_record(id_num)
	puts "\e[H\e[2J"
	work = $db.execute("SELECT * FROM books where id = ?", id_num).first

	unless work
		puts "No such book"
		return
	end

	puts %Q{\t
	Title:\t\t#{work['title']}
	Author:\t\t#{work['author']}
	Language:\t#{work['language']}
	Country:\t#{work['country']}
	Subject:\t#{work['subject']}
	Year:\t\t#{work['year']}}
end


#main
homescreen
