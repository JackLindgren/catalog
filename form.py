import curses

screen = curses.initscr()

def main():
	#curses.noecho()
	curses.echo()
	curses.cbreak()
	screen.keypad(1)
	drawForm()
	x = 4
	y = 0
	screen.getstr(y,x)
	while True:
		event = screen.getch()
		if event == ord("q"): break
		elif event == curses.KEY_UP and y > 0:
			y = y - 1
			screen.getstr(y, x)
		elif event == curses.KEY_DOWN and y < 3:
			y = y + 1
			screen.getstr(y, x)
		#elif event == curses.KEY_RIGHT and x < 20:
			#screen.getstr(y,x)
			#screen.move(y,x)
		#elif event == curses.KEY_LEFT and x > 4:
			#x = x - 1
			#screen.getstr(y,x)
			#screen.move(y,x)

def drawForm():
	fields = ["abc", "def", "ghi", "jkl"]
	for f in fields:
		screen.addstr(f + "\n")

main()

curses.nocbreak(); screen.keypad(0); curses.echo()
curses.endwin()
