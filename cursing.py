import curses

actions = []
for i in range(1, 60):
	actions.append("{0}\n".format(i))

def paginate(p):
	# takes a page number and returns the items belonging to that page
	pageLength = 15	#each page will have max 15 items

	if len(actions) % pageLength == 0:
		pageCount = len(actions) / pageLength
	else:
		pageCount = ( len(actions) / pageLength ) + 1
#	start = p * ( pageLength - 1)
	start = (p * pageLength) - pageLength
	end   = p * pageLength
	return actions[start:end]

def Nscreen(n, items):
	i = 0
	while i < len(items):
		if i == n:
			screen.addstr(items[i], curses.A_REVERSE)
		else:
			screen.addstr(items[i])
		i = i + 1

def EnterScreen(k, items):
	screen.addstr("You pressed a button!\n")
	screen.addstr(items[k])

def main(row, page):
	curses.noecho()
	curses.curs_set(0)
	screen.keypad(1)

	while True:
		event = screen.getch()
#		items = paginate(page)
		if event == ord("q"): break
		elif event == curses.KEY_DOWN and row != len(items) - 1:
			screen.clear()
			Nscreen(row + 1, items)
			row = row + 1
		elif event == curses.KEY_UP and row != 0:
			screen.clear()
			Nscreen(row - 1, items)
			row = row - 1
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
