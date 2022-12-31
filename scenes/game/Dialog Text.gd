extends RichTextLabel

signal dialog_complete

var typing_speed = 0.05

var current_char = 0
var display = ""
var current_message = 0
var next_char_timer
var new_message setget set_new_message

var is_in_bbcode = false

func set_new_message(message):
	current_char = 0
	current_message = message
	self.bbcode_text = ""
	display = ""

	next_char_timer = Timer.new()
	next_char_timer.set_wait_time(typing_speed)
	next_char_timer.connect("timeout", self, "_on_next_char_timeout")
	add_child(next_char_timer)
	next_char_timer.start()

func _on_interrupt_dialog():
		var dialog_man = get_parent()
		var sounds = dialog_man.speaker_data[dialog_man.current_speaker].sounds
		display = current_message

		self.bbcode_text = display

		var sfx = get_node("../Dialog SFX")
		sfx.stream = load(sounds[current_char % len(sounds)])
		sfx.pitch_scale = rand_range(0.9, 1.1)
		sfx.play()

		if next_char_timer:
			next_char_timer.stop()
			next_char_timer.queue_free()

		emit_signal("dialog_complete")


func _on_next_char_timeout():
	if current_char < len(current_message):
		var dialog_man = get_parent()
		var sounds = dialog_man.speaker_data[dialog_man.current_speaker].sounds
		var next_char = current_message[current_char]
		if next_char == '[':
			var ending_index = -1
			for i in range(current_char, len(current_message)):
				if current_message[i] == ']':
					ending_index = i
					break
			
			var current_bbcode = current_message.substr(current_char, (ending_index - current_char) + 1)

			current_char = current_char + len(current_bbcode)
			display += current_bbcode
			_on_next_char_timeout()
		else:
			display += next_char
			current_char += 1

		self.bbcode_text = display

		if sounds && current_char % 2 == 0:
			var sfx = get_node("../Dialog SFX")
			sfx.stream = load(sounds[(current_char / 2) % len(sounds)])
			sfx.pitch_scale = rand_range(0.9, 1.1)
			sfx.play()
	else:
		next_char_timer.stop()
		next_char_timer.queue_free()
		emit_signal("dialog_complete")
