extends Area2D

var player

func _ready():
	var how_to = get_node("/root/World/Player/How to Interact")
	player = get_node("/root/World/Player")

	self.connect("body_exited", how_to, "area_exited")
	self.connect("body_entered", how_to, "area_entered")

func _process(delta):
	if overlaps_body(player) && Input.is_action_just_pressed("ui_accept"):
		get_tree().change_scene("res://scenes/game/Nightmare.tscn")