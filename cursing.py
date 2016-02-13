import curses

#actions = ["A\n", "B\n", "C\n", "D\n"]
actions = []
for i in range(1, 15):
	actions.append("{0}\n".format(i))

def Nscreen(n):
	# takes a number, n
	# displays the options
	# with option "n" in reverse to show it's selected
	i = 0
	while i < len(actions):
		if i == n:
			screen.addstr(actions[i], curses.A_REVERSE)
		else:
			screen.addstr(actions[i])
		i = i + 1

def EnterScreen(k):
	screen.addstr("You pressed a button!\n")
	screen.addstr(actions[k])

def main(curScreen):
	curses.noecho()
	curses.curs_set(0)
	screen.keypad(1)

	while True:
		event = screen.getch()
		if event == ord("q"): break
		elif event == curses.KEY_DOWN and curScreen != len(actions) - 1:
			screen.clear()
			Nscreen(curScreen + 1)
			curScreen = curScreen + 1
		elif event == curses.KEY_UP and curScreen != 0:
			screen.clear()
			Nscreen(curScreen - 1)
			curScreen = curScreen - 1
		elif event == 10:
			screen.clear()
			EnterScreen(curScreen)
			# if curScreen == 0:
			# 	curses.nocbreak(); screen.keypad(0); curses.echo()
			# 	curses.endwin()
			# 	main(0)

curScreen = 0

screen = curses.initscr()
# curses.noecho()
# curses.curs_set(0)
# curses.keypad(1)

Nscreen(curScreen)
main(0)

curses.nocbreak(); screen.keypad(0); curses.echo()
curses.endwin()