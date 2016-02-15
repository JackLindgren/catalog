import curses
import os

actions = []
for i in range(1, 73):
	actions.append("line number: {0}\n".format(i))

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
		self.author = int((8.0  / 34) * int(columns))
		self.title  = int((12.0 / 34) * int(columns))
		self.year   = 5
		self.country= int((4.0  / 34) * int(columns))
		self.lang   = int((4.0  / 34) * int(columns))
		self.subj   = int((4.0  / 34) * int(columns))
		self.rows   = int(rows)

# tput cols - then we can get the number of columns 
# which will let us divide the fields proportionally
# e.g. "title" takes up 1/5, author takes up 1/5, etc.

# row, columns = os.popen('stty size', 'r').read().split()

# author = 8  / 34
# title  = 12 / 34
# year   = 2  / 34
# country= 4  / 34
# lang   = 4  / 34
# subj   = 4  / 34

def lastPage(p):
	useRows = PageInfo()
	pageLength = useRows.rows - 5
#	pageLength = 15
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
	i = 0
	while i < len(items):
		if i == n:
			screen.addstr(items[i], curses.A_REVERSE)
		else:
			screen.addstr(items[i])
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

			#row = 14
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
