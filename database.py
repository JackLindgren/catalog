import sqlite3

class book:
        def __init__(self, title, author, country, language, topic, year):
                self.title = title
		self.author = author
		self.country = country
		self.language = language	
		self.topic = topic
		self.year = year

conn = sqlite3.connect("lib_catalog")

c = conn.cursor()

GermanBooks = c.execute("SELECT * FROM books WHERE language is 'German'")

bookObjects = []

for entry in GermanBooks:
	bookObjects.append(book(entry[1], entry[2], entry[3], entry[4], entry[5], entry[6] ))

for item in bookObjects:
	print item.title[:15].ljust(15), item.author[:15].ljust(15)

#>>> print "abc".ljust(10), "def".ljust(10)
