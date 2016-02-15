import curses
import os
import sqlite3

class Book:
	def __init__(self, bookData):
		self.year = bookData[6]
		self.topic = bookData[5]
		self.title = bookData[1]
		self.author = bookData[2]
		self.country = bookData[3]
		self.language = bookData[4]

conn = sqlite3.connect("lib_catalog")
c = conn.cursor()
AllBooks = c.execute("SELECT * FROM books ORDER BY author, year")
bookObjects = []
for entry in AllBooks:
	bookObjects.append(Book(entry))

actions = bookObjects

#actions = []
#for i in range(1, 73):
#	actions.append("line number: {0}\n".format(i))

def paginate(p):
	# takes a page number and returns the items belonging to that page
	# useRows is a PageInfo object which will have a "rows" attribute
	# which tells us the number of rows available on the current terminal
	useRows = PageInfo()
	pageLength = useRows.rows - 5

	if len(actions) % pageLength == 0:
		pageCount = len(actions) / pageLength
	else:
		pageCount = ( len(actions) / pageLength ) + 1
	start = (p * pageLength) - pageLength
	end   = p * pageLength
	return actions[start:end]

class PageInfo:
	def __init__(self):
		rows, columns = os.popen('stty size', 'r').read().split()
		self.auth = int((8.0  / 34) * int(columns))
		self.titl = int((12.0 / 34) * int(columns))
		self.year = 5
		self.coun = int((4.0  / 34) * int(columns))
		self.lang = int((4.0  / 34) * int(columns))
		self.subj = int((4.0  / 34) * int(columns))
		self.rows = int(rows)

def lastPage(p):
	useRows = PageInfo()
	pageLength = useRows.rows - 5
	if len(actions) % pageLength == 0:
		pageCount = len(actions) / pageLength
	else:
		pageCount = ( len(actions) / pageLength ) + 1
	if p == pageCount:
		return True
	else:
		return False

def Nscreen(n, items):
	if n == -1:
		screen.addstr("Back\n", curses.A_REVERSE)
	else:
		screen.addstr("Back\n")

	form = PageInfo()

	i = 0
	while i < len(items):
		if i == n:
			screen.addstr(items[i].title, items[i].author, curses.A_REVERSE)
			#screen.addstr(items[i], curses.A_REVERSE)
		else:
			screen.addstr(items[i].title, items[i].author)
			#screen.addstr(items[i])
		i = i + 1
	if n == len(items):
		screen.addstr("Next\n", curses.A_REVERSE)
	else:
		screen.addstr("Next\n")

def EnterScreen(k, items):
	screen.addstr("You pressed a button!\n")
	screen.addstr(items[k])

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

		elif event == 10:
			screen.clear()
			EnterScreen(row, items)

#curScreen = 0
row = 0
page = 1

screen = curses.initscr()
# curses.noecho()
# curses.curs_set(0)
# curses.keypad(1)

#Nscreen(curScreen)
items = paginate(page)
Nscreen(row, items)
main(0, page)

curses.nocbreak(); screen.keypad(0); curses.echo()
curses.endwin()
