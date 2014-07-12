require 'rubygems'
require 'sqlite3'

$db = SQLite3::Database.new("dbfile")

def find_author
  puts "Enter the last name of the author you're looking for"
  id = gets.chomp

  writers = $db.execute("SELECT DISTINCT auth_first || ' ' || auth_last FROM books WHERE auth_last = ?", id)

  if writers.size > 1
    puts "There is more than one writer with that name. Which did you mean?"
    writers.each{|x| puts x}
    puts "Please enter the first name"
    first_name = gets.chomp
    complex_writers(first_name, id)
  elsif writers.size == 0
    puts "There are no exact matches with that name"
    writers = $db.execute("SELECT DISTINCT auth_first || ' ' || auth_last FROM books WHERE auth_last LIKE ?", "%#{id}%")
    puts "Did you want:"
    writers.each{|x| puts x}
    puts "Enter the name. Last, First"
    name = gets.chomp.split(/, /)
    complex_writers(name[1], name[0])
  elsif writers.size == 1
    easy_writers(id)
  end
end

def complex_writers(first, last)
  $db.results_as_hash = true
  $db.execute("SELECT * FROM books WHERE auth_first = ? AND auth_last = ?", "#{first}", "#{last}").each do |n|
    auth = n
    print_info(auth)
  end
end

def easy_writers(author)
  $db.results_as_hash = true #only turn this on if you have a simple case
  $db.execute("SELECT * FROM books WHERE auth_last = ?", "#{author}").each do |n|
    auth = n
    print_info(auth)
  end
end

def print_info(param)
  book = param
  puts %Q{Title:\t#{book['title']} (#{book['year']})}
end

find_author
