require 'rubygems'
require 'sqlite3'

$db = SQLite3::Database.new("dbfile")
$db.results_as_hash = true

def add_book
  puts "\t\t\t\tEnter the title:"
  print "\t\t\t\t"
  title = gets.chomp
  puts "\t\t\t\tEnter the author's first name:"
  print "\t\t\t\t"
  auth_first = gets.chomp
  puts "\t\t\t\tEnter the author's last name:"
  print "\t\t\t\t"
  auth_last = gets.chomp
  puts "\t\t\t\tEnter the country:"
  print "\t\t\t\t"
  country = gets.chomp
  puts "\t\t\t\tEnter the language:"
  print "\t\t\t\t"
  lang = gets.chomp
  puts "\t\t\t\tEnter the genre:"
  print "\t\t\t\t"
  genre = gets.chomp
  puts "\t\t\t\tEnter the year of publicaton:"
  print "\t\t\t\t"
  year = gets.chomp.to_i

  $db.execute("INSERT INTO books (title, auth_first, auth_last, country, language, genre, year) VALUES (?, ?, ?, ?, ?, ?, ?)", title, auth_first, auth_last, country, lang, genre, year)

  puts "Great!"
  home_screen
end

def edit_entry
  puts "\e[H[\e[2J"
  puts "not yet available"
end

def setup
  puts "Creating the library..."
  $db.execute %q{
    CREATE TABLE books (
    id integer primary key,
    title varchar(20),
    auth_first varchar(20),
    auth_last varchar(20),
    country varchar(20),
    language varchar(20),
    genre varchar(20),
    year integer)
  }
end

def home_screen
  puts "\e[H\e[2J"
  puts "\t\t\t\tWelcome to the administrative screen."
  puts "\n\n\t\t\t\tWhat would you like to do?"
  puts "\n\t\t\t\t1 = Add a book to the catalog"
  puts "\n\t\t\t\t2 = Edit an existing entry"
  puts "\n\t\t\t\t3 = Run the database setup utility"
  puts "\n\t\t\t\tq = Exit"

  print "\n\n\t\t\t\t"
  choice = gets.chomp.to_i
  if choice == 1
    add_book
  elsif choice == 2
    edit_entry
  elsif choice == 3
    setup
  end

end

home_screen
