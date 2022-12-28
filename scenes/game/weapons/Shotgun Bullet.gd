extends Area2D

export (int) var speed = 100
export (int) var damage = 1

var globals

func _ready():
	globals = get_node("/root/Globals")
	var timer = Timer.new()
	timer.one_shot = true
	timer.wait_time = .6 + .3 * randf()
	timer.connect("timeout", self, "_destroy") 
	add_child(timer)
	timer.start()

	self.connect("body_entered", self, "_on_body_entered")


func _destroy():
	queue_free()

func _explode():
	var p = get_node("Blood").duplicate()
	p.position = self.global_position
	p.rotation = self.global_rotation

	get_node("/root/Globals").get_main_node().add_child(p)
	p.emitting = true

func _on_body_entered(node):
	if !globals.networked || is_network_master():
		if node.has_method("damage"):
			var c_health = node.health
			node.call("damage", damage)
			damage -= c_health

			if damage <= 0:
				_explode()
				queue_free()

func _process(delta):
	var velocity = Vector2(1, 0)
	position += velocity.rotated(self.rotation) * delta * speed
