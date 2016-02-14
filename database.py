import sqlite3

conn = sqlite3.connect("lib_catalog")

c = conn.cursor()

GermanBooks = c.execute("SELECT * FROM books WHERE language is 'German'")

for book in GermanBooks:
	print book[1]
