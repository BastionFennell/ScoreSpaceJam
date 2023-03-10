extends Area2D

var has_interacted = false
var is_faded_in = false
var player
var globals
var is_visible
var interact_timer
var can_interact = false

func _ready():
	player = get_parent()
	globals = get_node("/root/Globals")

	var globals = get_node("/root/Globals")
	has_interacted = globals.has_interacted
	self.connect("area_entered", self, "_on_area_entered")
	self.connect("area_exited", self, "_on_area_exited")

	interact_timer = Timer.new()
	interact_timer.set_wait_time(0.5)
	interact_timer.connect("timeout", self, "_can_interact")
	add_child(interact_timer)

	interact_timer.start()

	if !has_interacted:
		globals.connect("has_interacted", self, "_on_first_interaction")
	else:
		self.visible = false

func _can_interact():
	can_interact = true
	remove_child(interact_timer)
	interact_timer.queue_free()

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

func _on_area_entered(body):
	if "is_interactive" in body && body.is_interactive:
		if body.has_method("on_player_entered"):
			body.on_player_entered()
		fade_in()
		is_visible = true

func _on_area_exited(body):
	if  "is_interactive" in body:
		if body.is_interactive && body.has_method("on_player_exited"):
			body.on_player_exited()

	var should_be_visible = false
	for a in get_overlapping_areas():
		should_be_visible = should_be_visible || ("is_interactive" in a && a.is_interactive)
	
	if !should_be_visible:
		fade_out()

func _process(_delta):
	if can_interact && Input.is_action_just_pressed("ui_accept") && !get_tree().paused:
		for a in get_overlapping_areas():
			if "is_interactive" in a && a.is_interactive && a.has_method("on_interact"):
				a.on_interact()
