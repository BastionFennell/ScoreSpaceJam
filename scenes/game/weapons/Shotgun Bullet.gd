extends KinematicBody2D

export (int) var speed = 25
export (int) var damage = 5

func _ready():
		var timer = Timer.new()
		timer.one_shot = true
		timer.wait_time = .6 + .3 * randf()
		timer.connect("timeout", self, "_destroy") 
		add_child(timer)
		timer.start()

func _destroy():
	queue_free()

func _explode():
	var p = get_node("Blood").duplicate()
	p.position = self.global_position
	p.rotation = self.global_rotation

	get_node("/root/World").add_child(p)
	p.emitting = true

func _process(delta):
	var velocity = Vector2(1, 0)
	var collision = move_and_collide(velocity.rotated(self.rotation) * speed)
	if collision && collision.collider.has_method("damage"):
		collision.collider.call("damage", damage)
		_explode()
		queue_free()
