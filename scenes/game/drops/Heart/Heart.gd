extends KinematicBody2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var player
var collected = false

# Called when the node enters the scene tree for the first time.
func _ready():
	player = get_node("/root/World/Player")
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(_delta):
	var velocity = Vector2.ZERO
	if (position.distance_to(player.position) < 10  && !collected):
		collected = true
		_pickUp()


func _pickUp():
	player._on_damage(-1)
	queue_free()
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
