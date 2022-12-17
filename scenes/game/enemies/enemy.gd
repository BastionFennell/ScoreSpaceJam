extends KinematicBody2D

export (int) var speed = 300
export (int) var health = 50

var player
var dead = false

# Called when the node enters the scene tree for the first time.
func _ready():
	player = get_node("/root/World/Player")

func _explode():
	var p = get_node("Blood").duplicate()
	p.position = self.global_position

	get_node("/root/World").add_child(p)
	p.emitting = true


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(_delta):
	var velocity = Vector2.ZERO
	if (position.distance_to(player.position) > 10 && !dead):
		velocity += position.direction_to(player.position)
		move_and_slide(velocity * speed)

func damage(amount):
	health -= amount
	if health <= 0:
		dead = true
		self.visible = false
		self.remove_child(get_node("CollisionShape2D"))

		_explode()

		var ded = get_node("Ded")
		ded.playing = true
		yield(ded, "finished")
		queue_free()
	else:
		get_node("Oof").playing = true
