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
  puts "t = title"
  puts "a = author"
  puts "c = country"
  puts "l = language"
  puts "g = genre"
  puts "y = year"
  puts "b = go back"
  choice = gets.chomp
  if choice == "t"
    find_title
  elsif choice == "a"
    find_author
  elsif choice == "c"
    find_country
  elsif choice == "l"
    find_language
  elsif choice == "g"
    find_genre
  elsif choice == "y"
    find_year
  elsif choice == "b"
    home_screen
  else
    puts "Please choose a valid option!"
    puts "\e[H\e[2J"
    lookup
  end
end

def find_language
  puts "\e[H\e[2J"
  puts "Enter the language you're looking for:"
  puts "Or, for a list of languages, enter 'b'"
  lang = gets.chomp
  if lang == "b"
    $db.execute("SELECT DISTINCT language FROM books").each do |n|
      puts %Q{#{n['language']}\n}
    end
    puts "Which language would you like the listing for?"
    lang = gets.chomp
    $db.execute("SELECT * FROM books WHERE language LIKE ?", "%#{lang}%").each do |n|
      lang = n
      puts %Q{Title:\t\t#{lang['title']}\n}
    end
  else
    $db.execute("SELECT * FROM books WHERE language = ?", lang).each do |n|
      language = n
      puts %Q{Title:\t\t#{language['title']}
  Country:\t#{language['country']}
  \n}
    end
  end

  puts "Press any key to return to home"
  ans = gets.chomp
  ans.scan(/./)
    home_screen

end

def find_author
  puts "\e[H\e[2J"
  puts "Enter the author's last name"
  author = gets.chomp
  $db.execute("SELECT * FROM books WHERE auth_last LIKE ?", "%#{author}%").each do |n|
    auth = n
#    puts %Q{\n\nTitle:\t#{auth['title']}, #{auth['year']}\n}
    print_info(auth)
    print "\n"
  end

  puts "Press any key to return to home"
  ans = gets.chomp
  ans.scan(/./)
    home_screen
end

def find_country
  puts "\e[H\e[2J"
  puts "Enter the country you're looking for:"
  puts "Or, for a list of countries, enter 'b'"
  country = gets.chomp
  if country == "b"
    $db.execute("SELECT DISTINCT country FROM books").each do |n|
      puts %Q{#{n['country']}\n}
    end
    puts "Which country would you like the listing for?"
    country = gets.chomp
    $db.execute("SELECT * FROM books WHERE country LIKE ?", "%#{country}%").each do |n|
      country = n
      puts %Q{Title:\t\t#{country['title']}
  Language:\t#{country['language']}
  \n}
    end
  else
    $db.execute("SELECT * FROM books WHERE country LIKE ?", "%#{country}%").each do |n|
      country = n
      puts %Q{Title:\t\t#{country['title']}
  Language:\t#{country['language']}
  \n}
    end
  end

  puts "Press any key to return to home"
  ans = gets.chomp
  ans.scan(/./)
    home_screen
end

def find_genre
  puts "\e[H\e[2J"
  puts "Enter the genre you're looking for:"
  puts "Or, for a list of genres, enter 'b'"
  genre = gets.chomp
  if genre == "b"
    $db.execute("SELECT DISTINCT genre FROM books").each do |n|
      puts %Q{#{n['genre']}\n}
    end
    puts "Which genre would you like the listing for?"
    genre = gets.chomp
    $db.execute("SELECT * FROM books WHERE genre LIKE ?", "%#{genre}%").each do |n|
      genre = n
      puts %Q{Title:\t\t#{genre['title']}\n}
    end
  else
    $db.execute("SELECT * FROM books WHERE genre LIKE ?", "%#{genre}%").each do |n|
      genre = n
      puts %Q{Title:\t\t#{genre['title']}
  Author:\t\t#{genre['auth_first']} #{genre['auth_last']}
  Language:\t#{genre['language']}
  Country:\t#{genre['country']}
  \n}
    end
  end

  puts "Press any key to return to home"
  ans = gets.chomp
  ans.scan(/./)
    home_screen
end

def print_info(param)
  book = param
  puts %Q{Title:\t\t#{book['title']}
Author:\t\t#{book['auth_first']} #{book['auth_last']}
Country:\t#{book['country']}
Language:\t#{book['language']}
Year:\t\t#{book['year']}}

#  puts "Press any key to go home"
#  answer = gets.chomp
#  answer.scan(/./)
#    home_screen
end

def find_title
  puts "\e[H\e[2J"
  puts "Enter the title of the book"
  title = gets.chomp
  book = $db.execute("SELECT * FROM books WHERE title LIKE ?", "%#{title}%").first	#best way

  unless book
    puts "No result found"
    puts "\n\nContinue?"
    answer = gets.chomp
    answer.scan(/./)
      home_screen
  end
  print_info(book)

  puts "Press any key to go home"
  answer = gets.chomp
  answer.scan(/./)
    home_screen

end


# begin main body of the program
home_screen
