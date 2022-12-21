extends Node2D

var has_interacted = false
var is_faded_in = false
var player

func _ready():
	player = get_parent()

	var globals = get_node("/root/Globals")
	has_interacted = globals.has_interacted

	if !has_interacted:
		globals.connect("has_interacted", self, "_on_first_interaction")
	else:
		self.visible = false

func _on_first_interaction():
	# Commenting this out for now, since this makes it way more obvious what you can or can't interact with
	# has_interacted = true
	fade_out()

func fade_out():
	get_node("Fader").play("Fade out")
	is_faded_in = false

func fade_in():
	if !has_interacted && !is_faded_in:
		get_node("Fader").play("Fade in")
		is_faded_in = true

func area_entered(body):
	if body == player:
		fade_in()

func area_exited(body):
	if body == player:
		fade_out()
