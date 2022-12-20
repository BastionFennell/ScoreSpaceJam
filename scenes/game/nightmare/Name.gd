extends TextEdit

export(int) var LIMIT = 15

var current_text = ''
var cursor_line = 0
var cursor_column = 0

func _ready():
	self.connect("text_changed", self, "_on_text_changed")

func _on_text_changed():
	var new_text : String = self.text
	if new_text.length() > LIMIT:
		self.text = current_text
		# when replacing the text, the cursor will get moved to the beginning of the
		# text, so move it back to where it was 
		self.cursor_set_line(cursor_line)
		self.cursor_set_column(cursor_column)

	current_text = self.text
	# save current position of cursor for when we have reached the limit
	cursor_line = self.cursor_get_line()
	cursor_column = self.cursor_get_column()
