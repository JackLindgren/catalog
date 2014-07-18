require 'rubygems'
require 'sqlite3'
$db = SQLite3::Database.new("lib_catalog")
$db.results_as_hash = true

def find_author
	puts "\e[H\e[2J"
	puts "\n\n\t\t\t\t\tEnter the name of the author you want (Last, First)"
	print "\t\t\t\t\t"
	id = gets.chomp

	if id == "q"
		exit
	end

	puts "\n"

	counter = 0

# searches for exact matches first
	$db.execute("SELECT * FROM books WHERE author = ?", id).each do |n|
		auth = n
		puts %Q{\n\n\t\t\t\t\t#{auth['author']}\t//\t#{auth['title']} (#{auth['year']})}
		counter += 1
	end

# if no exact matches are found, searches for approximate matches
	if counter == 0
		$db.execute("SELECT * FROM books WHERE author LIKE ?", "%#{id}%").each do |n|
			auth = n
			puts %Q{\n\n\t\t\t\t\t#{auth['author']}\t//\t#{auth['title']} (#{auth['year']})}
			counter += 1
		end
	end

# if no approximate matches are found, apologizes and returns home
	if counter == 0
		puts "\n\n\t\t\t\t\tSorry, no results were found"
	end		

	puts "\n\n\t\t\t\t\tto return to the home screen, press any key and hit enter"
	print "\t\t\t\t\t"
	key = gets.chomp
	key.scan(/./)
		find_author
end	

find_author
