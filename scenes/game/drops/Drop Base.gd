extends KinematicBody2D

var player
var collected = false

func _ready():
	player = get_node("/root/Globals").get_player()
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(_delta):
	var velocity = Vector2.ZERO
	if (position.distance_to(player.position) < 10  && !collected):
		collected = true
		_pickUp()
		queue_free()


func _pickUp():
	print("Override pickup script in child component")
