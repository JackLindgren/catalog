import curses
import os
import sqlite3
import sys

reload(sys)
sys.setdefaultencoding('UTF8')


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

def getBooks():
	# connects to the database, gets all the books, and returns an array of book objects
	conn = sqlite3.connect("lib_catalog")
	c = conn.cursor()
	AllBooks = c.execute("SELECT * FROM books ORDER BY author, year")
	bookObjects = []
	for entry in AllBooks:
		bookObjects.append(Book(entry))
	return bookObjects

def rowFormat(entry):
	# the formatting is found in a PageInfo object which tells us how wide each column should be, based on the width of the current terminal
	format = PageInfo()
	return entry.author[:format.auth].ljust(format.auth) + entry.title[:format.titl].ljust(format.titl) + str(entry.year)[:format.year].ljust(format.year) + entry.country[:format.coun].ljust(format.coun) + entry.language[:format.lang].ljust(format.lang) + "\n"

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

def Nscreen(n, pageItems):
	# writes the current screen - really just moves the cursor up and down
	# pageItems is an array with the current page's items (take from the main array)
	screen.addstr("Back\n")
	i = 0
	while i < len(pageItems):
		if i == n:
			screen.addstr(rowFormat(pageItems[i]), curses.A_REVERSE)
			# try:
			# 	screen.addstr(rowFormat(pageItems[i]), curses.A_REVERSE)
			# except UnicodeEncodeError:
			# 	screen.addstr("x\n", curses.A_REVERSE)
		else:
			screen.addstr(rowFormat(pageItems[i]))
			# try:
			# 	screen.addstr(rowFormat(pageItems[i]))
			# except UnicodeEncodeError:
			# 	screen.addstr("x\n")
		i = i + 1
	screen.addstr("Next\n")

def EnterScreen(k, items):
	# displays info about the current selection
	screen.addstr("You pressed a button!\n")
	screen.addstr("Title: " + items[k].title + "\n")
	screen.addstr("Author: " + items[k].author + "\n")
	screen.addstr("Year: " + str(items[k].year) + "\n")

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
			screen.clear()
			page = page - 1
			items = paginate(page)

			useRows = PageInfo()
			pageLength = useRows.rows - 6
			row = pageLength
			Nscreen(row, items)

		elif event == curses.KEY_LEFT and page != 1:
			screen.clear()
			page = page - 1
			items = paginate(page)
			Nscreen(row, items)
		elif event == curses.KEY_RIGHT and (lastPage(page) != True):
			screen.clear()
			page = page + 1
			items = paginate(page)
			Nscreen(row, items)

		elif event == 10:
			screen.clear()
			EnterScreen(row, items)

row = 0
page = 1

screen = curses.initscr()
# curses.noecho()
# curses.curs_set(0)
# curses.keypad(1)

myBooks = getBooks()
#Nscreen(curScreen)

items = paginate(page)
Nscreen(row, items)
main(0, page)

curses.nocbreak(); screen.keypad(0); curses.echo()
curses.endwin()
