extends Node2D

var animator
var dialog_man

var dialog_i
var last_anim
var dialog = {
	"Character Waking Up": [
		{
			"text": "Woah... Where am I?",
			"character": "player"
		},
		{
			"text": "Is this some sort of temple? I don't recognize that statue...",
			"character": "player"
		},
		{
			"animation": "Statue Zoom"
		}
	],
	"Statue Zoom": [
		{
			"text": "Whatever god or goddess that is, they must have been neglected for years.",
			"character": "player"
		},
		{
			"end": true
		}
	]
}

func _ready():
	dialog_man = get_node("Dialog")
	animator = get_node("Cutscene Animator")

	dialog_man.connect("next", self, "_dialog_continue")
	animator.connect("animation_finished", self, "_animation_finished")

	animator.play("Character Waking Up")
	get_tree().paused = true


func _animation_finished(anim):
	if dialog.has(anim):
		last_anim = anim
		dialog_man.visible = true
		dialog_i = -1
		_dialog_continue()

func _dialog_continue():
	var next_dialog = dialog[last_anim][dialog_i + 1]
	if next_dialog.has("end"):
		dialog_man.visible = false
		self.visible = false
		get_node("Cutscene Camera").current = false
		get_node("../Players").visible = true
		get_tree().paused = false
		get_node("/root/Globals").get_player().get_node("Camera").current = true

		queue_free()
	elif next_dialog.has("animation"):
		dialog_man.visible = false
		animator.play(next_dialog.animation)
	else:
		dialog_man.update_dialog_box(next_dialog.character, next_dialog.text)
		dialog_i += 1
