extends KinematicBody2D

export (int) var speed = 300

var player

# Called when the node enters the scene tree for the first time.
func _ready():
	player = get_node("/root/World/Player")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(_delta):
	var velocity = Vector2.ZERO
	if (position.distance_to(player.position) > 10):
		velocity += position.direction_to(player.position)
		move_and_slide(velocity * speed)



