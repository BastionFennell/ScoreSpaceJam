extends KinematicBody2D

export (int) var speed = 25
export (int) var damage = 5

func _ready():
		var timer = Timer.new()
		timer.one_shot = true
		timer.wait_time = 10
		timer.connect("timeout", self, "_destroy") 
		add_child(timer)
		timer.start()

func _destroy():
	queue_free()

func _explode():
	var p = CPUParticles2D.new()
	p.emitting = false
	p.color = "#db1515"
	p.speed_scale = 3
	p.initial_velocity = 100
	p.initial_velocity_random = 0.2
	p.explosiveness = 0.5
	p.lifetime = 1
	p.one_shot = true
	p.scale_amount = 10
	p.scale_amount_random = 0.5
	p.lifetime_randomness = 0.5
	p.gravity.y = 0
	p.position = self.global_position
	p.rotation = self.global_rotation
	p.direction.x = -1
	p.direction.y = 0

	get_node("/root/World").add_child(p)
	p.emitting = true

func _process(delta):
	var velocity = Vector2(1, 0)
	var collision = move_and_collide(velocity.rotated(self.rotation) * speed)
	if collision && collision.collider.has_method("damage"):
		collision.collider.call("damage", damage)
		_explode()
		queue_free()
