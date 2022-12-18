extends Area2D

var player

# Called when the node enters the scene tree for the first time.
func _ready():
	player = get_node("/root/World/Player")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if overlaps_body(player):
		get_tree().change_scene("res://scenes/game/Nightmare.tscn")
