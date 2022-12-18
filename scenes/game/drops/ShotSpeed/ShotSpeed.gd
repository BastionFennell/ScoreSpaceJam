extends KinematicBody2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var player
var gun
var collected = false

# Called when the node enters the scene tree for the first time.
func _ready():
	player = get_node("/root/World/Player")
	gun = player.find_node("Shotgun")
	
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(_delta):
	var velocity = Vector2.ZERO
	if (position.distance_to(player.position) < 10  && !collected):
		collected = true
		_pickUp()

func _pickUp():
	gun._temp_speed_buff()
	queue_free()
	
