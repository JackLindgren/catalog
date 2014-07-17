require 'rubygems'
require 'sqlite3'
$db = SQLite3::Database.new("lib_catalog")
$db.results_as_hash = true

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

	puts "\n\n\t\t\t\t\tTo return to the home screen, hit any kiss and press enter"
	print "\n\n\t\t\t\t\t"
	key = gets.chomp
	key.scan(/./)
		homescreen
end

def homescreen
	puts "\e[H\e[2J"
	puts "\n\n\t\t\t\t\tWhat would you like to do?"
	puts "\n\n\t\t\t\t\te = enter a book"
	puts "\n\n\t\t\t\t\ts = setup the database"
	puts "\n\n\t\t\t\t\tu = update a record"
	puts "\n\n\t\t\t\t\tf = update a field"
	puts "\n\n\t\t\t\t\tv = view all records"
	puts "\n\n\t\t\t\t\tq = quit"
	print "\n\n\t\t\t\t\t"	
	choice = gets.chomp

	if choice == "e" || choice == "E"
		add_book
	elsif choice == "s" || choice == "S"
		create_table
	elsif choice == "u" || choice == "U"
		update
	elsif choice == "v" || choice == "V"
		view_all
	elsif choice == "f" || choice == "F"
		edit_field
	elsif choice == "q" || choice == "Q"
		disconnect
	else
		homescreen
	end
end

def view_all
	puts "\e[H\e[2J"

# assigns everything to an array and prints that
	all_books = Array.new
	$db.execute("SELECT * FROM books").each do |n|
		book = n
		all_books.push("\t%-25s %-40s %-6s %-15s %-15s %-20s %-4s" % [book['author'], book['title'], book['year'], book['country'], book['language'], book['subject'], book['id']])
	end

	all_books.sort!

	puts "\t\t%-25s %-40s %-6s %-15s %-15s %-20s %-4s" % ["Author", "Title", "Year", "Country", "Language", "Subject", "ID \#"]
	puts "\n"

#	i = 0
#	while i < all_books.length
#		puts "\t#{i+1}  #{all_books[i]}"
#		i += 1
#	end

	i = 0
	j = 0
	k = 15
	while i <= all_books.length
		puts"\e[H\e[2J"
		puts "\t\t%-25s %-40s %-6s %-15s %-15s %-20s %-4s" % ["Author", "Title", "Year", "Country", "Language", "Subject", "ID \#"]
		puts "\n"
		while i >= j && i < k
			puts "\t#{i+1}  #{all_books[i]}"
			i += 1
		end
		puts "press enter"
		key = gets.chomp
		key.scan(/./)
			k += 15
	end

# the record ID number is in line[-4..-2].to_i, for getting a match

	puts "\n\n\t\t\t\t\tTo retrun home, press enter"
	choice = gets.chomp
	choice.scan (/./)
		homescreen
end

def update

	puts "\e[H\e[2J"

	all_books = Array.new
	$db.execute("SELECT * FROM books").each do |n|
		book = n
		all_books.push("\t%-25s %-40s %-6s %-15s %-15s %-20s %-4s" % [book['author'], book['title'], book['year'], book['country'], book['language'], book['subject'], book['id']])
	end

	all_books.sort!

	puts "\t\t%-25s %-40s %-6s %-15s %-15s %-20s %-4s" % ["Author", "Title", "Year", "Country", "Language", "Subject", "ID \#"]
	puts "\n"

	i = 0
	j = 0
	k = 15
	while i <= all_books.length
		puts"\e[H\e[2J"
		puts "\t\t%-25s %-40s %-6s %-15s %-15s %-20s %-4s" % ["Author", "Title", "Year", "Country", "Language", "Subject", "ID \#"]
		puts "\n"
		while i >= j && i < k
			puts "\t#{i+1}  #{all_books[i]}"
			i += 1
		end
		puts "Enter a record number and press ENTER to access that book. Otherwise, press ENTER"
		key = gets.chomp.to_i
		if key > 0
			call_record(key)
			edit_record(key)
			break
		elsif key == 0
			k += 15
		end
	end
	puts "To return home, press enter"
	thing = gets.chomp
	thing.scan(/./)
		homescreen

end

def edit_record(id_num)
	puts "\n\n"

	puts "Enter the new title (or leave blank)"
	title = gets.chomp
	if title != ""
		$db.execute("UPDATE books SET title = ? WHERE id = ?", title, id_num)
	end

	puts "Enter the new author (or leave blank)"
	auth = gets.chomp
	if auth != ""
		$db.execute("UPDATE books SET author = ? WHERE id = ?", auth, id_num)
	end

	puts "Enter the new language (or leave blank)"
	language = gets.chomp
	if language != ""
		$db.execute("UPDATE books SET language = ? WHERE id = ?", language, id_num)
	end

	puts "Enter the new country (or leave blank)"
	country = gets.chomp
	if country != ""
		$db.execute("UPDATE books SET country = ? WHERE id = ?", country, id_num)
	end

	puts "Enter the new subject (or leave blank)"
	subject = gets.chomp
	if subject != ""
		$db.execute("UPDATE books SET subject = ? WHERE id = ?", subject, id_num)
	end

	puts "Enter the new year (or leave blank)"
	year = gets.chomp
	if year != ""
		$db.execute("UPDATE books SET year = ? WHERE id = ?", year.to_i, id_num)
	end

	puts "To see the new record, press any key"
	call_record(id_num)
	
	puts "To return to editing, please press 'R'"
	puts "To return home, press 'H'"
	option = gets.chomp
	if option == 'r' || option == 'R'
		edit_record(id_num)
	elsif option == 'h' || option == 'H'
		homescreen
	end
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

def edit_field
	puts "Which field would you like to edit?"
	puts "1 = country"
	puts "2 = language"
	puts "3 = subject"
	puts "(leave blank to go home)"
	field = gets.chomp
	if field == "1"
		$db.execute("SELECT DISTINCT country FROM books").each do |x|
			puts %Q{#{x['country']}}
		end
		puts "Enter the country to edit"
		puts "Leave blank to go home"
		old_c = gets.chomp
		if old_c == ""
			homescreen
		elsif old_c != ""
			puts "Enter the new name"
			new_c = gets.chomp
			puts "The COUNTRY field for all records labelled #{old_c} will be changed to #{new_c}"
			puts "continue? (y/n)"
			choice = gets.chomp
			if choice == "y" || choice == "Y"
				$db.execute("UPDATE books SET country = ? WHERE country = ?", new_c, old_c)
			else
				edit_field
			end

			puts "To return home, press enter"
			go = gets.chomp
			go.scan(/./)
				homescreen
		end

	elsif field == "2"
		$db.execute("SELECT DISTINCT language FROM books").each do |x|
			puts %Q{#{x['language']}}
		end
		puts "Enter the language to edit"
		old_l = gets.chomp
		puts "Enter the new name"
		new_l = gets.chomp
		puts "The LANGUAGE field for all records labelled #{old_l} will be changed to #{new_l}"
		puts "continue? (y/n)"
		choice = gets.chomp
		if choice == "y" || choice == "Y"
			$db.execute("UPDATE books SET language = ? WHERE language = ?", new_l, old_l)
		else
			edit_field
		end

		puts "To return home, press enter"
		go = gets.chomp
		go.scan(/./)
			homescreen

	elsif field == "3"
		$db.execute("SELECT DISTINCT subject FROM books").each do |x|
			puts %Q{#{x['subject']}}
		end
		puts "Enter the subject to edit"
		old_s = gets.chomp
		puts "Enter the new name"
		new_s = gets.chomp
		puts "The SUBJECT field for all records labelled #{old_s} will be changed to #{new_s}"
		puts "continue? (y/n)"
		choice = gets.chomp
		if choice == "y" || choice == "Y"
			$db.execute("UPDATE books SET subject = ? WHERE subject = ?", new_s, old_s)
		else
			edit_field
		end

		puts "To return home, press enter"
		go = gets.chomp
		go.scan(/./)
			homescreen

	else
		homescreen
	end

end	

homescreen
