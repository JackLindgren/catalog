require 'rubygems'
require 'sqlite3'

$db = SQLite3::Database.new("dbfile")
$db.results_as_hash = true

def disconnect
  $db.close
  puts "\e[H\e[2J"
  puts "Bye!"
  exit
end

def print_info(this_book)
# assigns it all to a has, "book"
  book = $db.execute("SELECT * FROM books WHERE title = ?", this_book).first

  unless book
    puts "No such book"
    return
  end

  puts %Q{#{book['title']} :: #{book['auth_first']} #{book['auth_last']} :: #{book['country']} :: #{book['year']}}
end

def home_screen
  puts "\e[H\e[2J" #clears the screen
  puts "What would you like to do today?"
  puts "l = Look up a book"
  puts "q = Exit"

  choice = gets.chomp
  if choice == "l"
    puts "\e[H\e[2J"
    lookup
  elsif choice == "q"
    disconnect
  end
end

def lookup
  puts "How would you like to search?"
  puts "a = author"
  puts "b = go back"
  choice = gets.chomp
  if choice == "a"
    find_author
  elsif choice == "b"
    home_screen
  else
    puts "Please choose a valid option!"
    puts "\e[H\e[2J"
    lookup
  end
end

def find_author
  puts "\e[H\e[2J"
  puts "Enter the author's last name"
  author = gets.chomp

  the_author = $db.execute("SELECT * FROM books WHERE auth_last = ?", author).first

  unless the_author
    puts "Did you mean:"
  end

  i = 1

  titles = Array.new

  

  $db.execute("SELECT * FROM books WHERE auth_last LIKE ?", "%#{author}%").each do |n|
    auth = n
    puts %Q{\n#{i} Title:\t#{auth['title']}, #{auth['year']}\n}
    titles.push(auth['title'])
    i += 1
  end

  puts "\n\nChoose a book by its number"
  num = gets.chomp.to_i
  while num > i || num < 0
    puts "Please choose a valid number"
    num = gets.chomp.to_i
  end

  current_book = titles[num-1]

  print_info(current_book)

  puts "\n\nPress any key to return to home"
  ans = gets.chomp
  ans.scan(/./)
    home_screen
end

# begin main body of the program
home_screen
