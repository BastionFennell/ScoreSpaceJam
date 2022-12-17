extends Area2D

export (int) var damage = 10

signal damage_player
var player

# Called when the node enters the scene tree for the first time.
func _ready():
	player = get_node("/root/World/Player")
	self.connect("damage_player", player, "_on_damage")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var dead = get_parent().dead
	if overlaps_body(player) && !dead:
		emit_signal("damage_player", damage * delta)
