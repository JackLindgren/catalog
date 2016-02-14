
class book:
	def __init__(self, title):
		self.title = title

	def save(self):
		if self.title and self.author:
			print "hello world"


ulysses = book("Ulysses")
ulysses.author = "Joyce, James"

ulysses.save()
