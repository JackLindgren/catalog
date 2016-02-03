books.txt       the poorly formatted book data
book_data.txt   the properly formatted book data (some of the fields were entered manually, but the "title::author" format was done automatically
bookfix.rb      takes the raw book data (i.e. "books.txt") and formats it properly (i.e. "book_data.txt")
makdedb.rb      takes the properly formatted book data ("book_data.txt") and enters it into an SQL database
bookdb          the database file

bookfix.rb(books.txt) -> book_data.txt
makedb.rb(book_data.txt) -> bookdb
