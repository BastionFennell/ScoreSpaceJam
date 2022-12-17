extends KinematicBody2D

export (int) var speed = 25

func _ready():
		var timer = Timer.new()
		timer.one_shot = true
		timer.wait_time = 10
		timer.connect("timeout", self, "_destroy") 
		add_child(timer)
		timer.start()

func _destroy():
	queue_free()

func _process(delta):
	var velocity = Vector2(1, 0)
	move_and_collide(velocity.rotated(self.rotation) * speed)
