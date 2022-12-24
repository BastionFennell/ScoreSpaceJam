extends Area2D

var globals 
var player

func _ready():
	globals = get_node("/root/Globals")

func connect_to_player(player):
	player = player 
	var how_to = player.get_node("How to Interact")
	self.connect("body_exited", how_to, "area_exited")
	self.connect("body_entered", how_to, "area_entered")

func _process(delta):
	if player && overlaps_body(player) && Input.is_action_just_pressed("ui_accept"):
		if !globals.has_interacted:
			globals.on_first_interact()

