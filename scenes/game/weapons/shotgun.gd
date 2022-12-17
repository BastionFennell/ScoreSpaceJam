extends KinematicBody2D

export (int) var reload_time = 2
export (int) var spread = 10

var Bullet = preload("res://scenes/game/weapons/Shotgun Bullet.tscn") 
var reloading = false;

func _animate_gunshot():
	get_node("Sprite").region_rect.position.x = 17
	var timer = Timer.new()
	timer.one_shot = true
	timer.wait_time = 0.1
	timer.connect("timeout", self, "_unanimate_gunshot") 
	add_child(timer)
	timer.start()

func _unanimate_gunshot():
	get_node("Sprite").region_rect.position.x = 1
	
func _spawn_single_bullet(rotation, position):
	var bullet = Bullet.instance()

	bullet.set_rotation(rotation)
	bullet.set_position(position)

	get_node('/root/World').add_child(bullet)

func _spawn_bullet():
	var spawner = get_node('./Bullet Spawner')

	for i in spread:
		_spawn_single_bullet(spawner.global_rotation + (randf() * 0.5 - 0.25), spawner.global_position)

func _on_shoot():
	if (!reloading):
		reloading = true
		_animate_gunshot()
		_spawn_bullet()

		var timer = Timer.new()
		timer.one_shot = true
		timer.wait_time = reload_time
		timer.connect("timeout", self, "_reload") 
		add_child(timer)
		timer.start()

func _reload():
	reloading = false

func _process(_delta):
	look_at(get_global_mouse_position())
	if Input.is_action_pressed("shoot"):
		_on_shoot()

