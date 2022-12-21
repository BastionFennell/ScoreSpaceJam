extends Area2D

var player
var world

func _ready():
	world = get_node("/root/Globals").get_main_node()
	player = get_node("/root/Globals").get_player()
	var how_to = player.get_node("How to Interact")

	self.connect("body_exited", how_to, "area_exited")
	self.connect("body_entered", how_to, "area_entered")

func _process(delta):
	if overlaps_body(player) && Input.is_action_just_pressed("ui_accept"):
		world.leave_twilight()