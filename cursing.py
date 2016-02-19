import curses
import os
import sqlite3
import locale
import time

locale.setlocale(locale.LC_ALL, "")
code = locale.getpreferredencoding()

class Book:
	def __init__(self, bookData):
		self.year     = bookData[6]
		self.topic    = bookData[5]
		self.title    = bookData[1]
		self.author   = bookData[2]
		self.country  = bookData[3]
		self.language = bookData[4]

class PageInfo:
	def __init__(self):
		rows, columns = os.popen('stty size', 'r').read().split()
		self.auth = int((8.0  / 34) * int(columns))
		self.titl = int((12.0 / 34) * int(columns))
		self.year = 6
		self.coun = int((4.0  / 34) * int(columns))
		self.lang = int((4.0  / 34) * int(columns))
		self.subj = int((4.0  / 34) * int(columns))
		self.rows = int(rows)
		self.cols = int(columns)

def getBooks(sortBy):
	# connects to the database, gets all the books, and returns an array of book objects
	conn = sqlite3.connect("lib_catalog")
	c = conn.cursor()
	if sortBy == "author":
		AllBooks = c.execute("SELECT * FROM books ORDER BY author, year")
	elif sortBy == "title":
		AllBooks = c.execute("SELECT * FROM books ORDER BY title, author, year")
	elif sortBy == "country":
		AllBooks = c.execute("SELECT * FROM books ORDER BY country, author, year")
	elif sortBy == "language":
		AllBooks = c.execute("SELECT * FROM books ORDER BY language, author, year")
	elif sortBy == "year":
		AllBooks = c.execute("SELECT * FROM books ORDER BY year, author, title")
	elif sortBy == "subject":
		AllBooks = c.execute("SELECT * FROM books ORDER BY subject, author, year")
	bookObjects = []
	for entry in AllBooks:
		bookObjects.append(Book(entry))
	return bookObjects

def rowFormat(entry):
	# the formatting is found in a PageInfo object which tells us how wide each column should be, based on the width of the current terminal
	format = PageInfo()
	return entry.author[:format.auth - 1].ljust(format.auth) + entry.title[:format.titl - 1].ljust(format.titl) + str(entry.year)[:format.year].ljust(format.year) + entry.country[:format.coun - 1].ljust(format.coun) + entry.language[:format.lang - 1].ljust(format.lang) + entry.topic[:format.subj - 1].ljust(format.subj) + "\n"

def paginate(p):
	# takes a page number and returns the items belonging to that page
	# useRows is a PageInfo object which will have a "rows" attribute which tells us the number of rows available on the current terminal
	useRows = PageInfo()
	pageLength = useRows.rows - 5

	if len(myBooks) % pageLength == 0:
		pageCount = len(myBooks) / pageLength
	else:
		pageCount = ( len(myBooks) / pageLength ) + 1

	start = (p * pageLength) - pageLength
	end   = p * pageLength
	return myBooks[start:end]

def lastPage(p):
	# tells us whether we are on the last page
	useRows = PageInfo()
	pageLength = useRows.rows - 5
	if len(myBooks) % pageLength == 0:
		pageCount = len(myBooks) / pageLength
	else:
		pageCount = ( len(myBooks) / pageLength ) + 1
	if p == pageCount:
		return True
	else:
		return False

def topLabel():
	format = PageInfo()
	label = "AUTHOR"[:format.auth - 1].center(format.auth) + "TITLE"[:format.titl - 1].center(format.titl) + "YEAR"[:format.year - 1].center(format.year) + "COUNTRY"[:format.coun - 1].center(format.coun) + "LANGUAGE"[:format.lang - 1].center(format.lang) + "SUBJECT"[:format.subj - 1].center(format.subj) + "\n"
	return str(label)

def Nscreen(n, pageItems):
	# writes the current screen - really just moves the cursor up and down
	# pageItems is an array with the current page's items (take from the main array)
	format = PageInfo()
	screen.addstr(sortBy.center(format.cols))
	label = topLabel()
	screen.addstr(label, curses.A_BOLD | curses.A_REVERSE)
	i = 0
	while i < len(pageItems):
		if i == n:
			screen.addstr(rowFormat(pageItems[i]).encode(code), curses.A_REVERSE)
		else:
			screen.addstr(rowFormat(pageItems[i]).encode(code))
		i = i + 1
	screen.addstr("Next\n")

def SingleBookInfo(k, items):
	screen.addstr("You pressed a button!\n")
	screen.addstr("Title: " + items[k].title.encode(code) + "\n")
	screen.addstr("Author: " + items[k].author.encode(code) + "\n")
	screen.addstr("Year: " + str(items[k].year) + "\n")
	screen.addstr("Country: " + items[k].country.encode(code) + "\n")
	screen.addstr("Language: " + items[k].country.encode(code) + "\n")
	screen.addstr("Subject: " + items[k].topic.encode(code) + "\n")


def SingleBook(k, items):
	# displays info about the current selection
	status = "edit"
	SingleBookInfo(k, items)
	screen.addstr("stay ", curses.A_REVERSE)
	screen.addstr("go back")
	while True:
		event = screen.getch()
		if event == ord("q"): break
		if event == curses.KEY_LEFT:
			screen.clear()
			SingleBookInfo(k, items)
			status = "stay"
			screen.addstr("stay ", curses.A_REVERSE)
			screen.addstr("go back ")
		elif event == curses.KEY_RIGHT:
			screen.clear()
			SingleBookInfo(k, items)
			status = "return"
			screen.addstr("stay ")
			screen.addstr("go back ", curses.A_REVERSE)
		elif event == 10 and status == "return": break

def main(row, page):
	curses.noecho()
	curses.curs_set(0)
	screen.keypad(1)

	while True:
		event = screen.getch()
		items = paginate(page)
		if event == ord("q"): break

		elif event == curses.KEY_DOWN and row != len(items) - 1:
			# draw the next screen down
			screen.clear()
			row = row + 1
			Nscreen(row, items)
		elif event == curses.KEY_DOWN and row == len(items) - 1 and (lastPage(page) != True):
			# go down a page and draw the next screen
			screen.clear()
			page = page + 1
			items = paginate(page)
			row = 0
			Nscreen(row, items)

		elif event == curses.KEY_UP and row != 0:
			# draw the next screen up
			screen.clear()
			row = row - 1
			Nscreen(row, items)
		elif event == curses.KEY_UP and row == 0 and page != 1:
			# go up a page and draw the next screen
			screen.clear()
			page = page - 1
			items = paginate(page)

			useRows = PageInfo()
			pageLength = useRows.rows - 6
			row = pageLength
			Nscreen(row, items)

		elif event == curses.KEY_LEFT and page != 1:
			# move the screen one page to the left (stay in the same row)
			screen.clear()
			page = page - 1
			items = paginate(page)
			Nscreen(row, items)
		elif event == curses.KEY_RIGHT and (lastPage(page) != True):
			# move the screen one page to the right (stay in the same row)
			screen.clear()
			page = page + 1
			items = paginate(page)
			if lastPage(page) == True and row > len(items) - 1:
				row = len(items) - 1
			Nscreen(row, items)

		elif event == 10:
			screen.clear()
			SingleBook(row, items)
			# why doesn't this return to the list screen??:
			screen.clear()
			Nscreen(row, items)

		elif event == ord(":"):
			screen.addstr(":")
			sortOpt = screen.getch()
			screen.addstr(chr(sortOpt))
			ent = screen.getch()
			if ent == 10:
				global myBooks
				global sortBy
				if sortOpt == ord("l"):
					myBooks = getBooks("language")
					sortBy = "LANGUAGE"
				elif sortOpt == ord("t"):
					myBooks = getBooks("title")
					sortBy = "TITLE"
				elif sortOpt == ord("a"):
					myBooks = getBooks("author")
					sortBy = "AUTHOR"
				elif sortOpt == ord("c"):
					myBooks = getBooks("country")
					sortBy = "COUNTRY"
				elif sortOpt == ord("y"):
					myBooks = getBooks("year")
					sortBy = "YEAR"
				elif sortOpt == ord("s"):
					myBooks = getBooks("subject")
					sortBy = "SUBJECT"
			items = paginate(page)
			screen.clear()
			Nscreen(row, items)



row = 0
page = 1

screen = curses.initscr()

myBooks = getBooks("author")
sortBy = "AUTHOR"

items = paginate(page)
Nscreen(row, items)
main(0, page)

curses.nocbreak(); screen.keypad(0); curses.echo()
curses.endwin()
