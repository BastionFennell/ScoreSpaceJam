extends KinematicBody2D

export (int) var reload_time = 2
export (int) var spread = 10
export (int) var screen_shake = 0.5

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

func _shake_camera():
	get_node("/root/World/Player/Camera2D").add_trauma(screen_shake)

func _on_shoot():
	if (!reloading):
		reloading = true
		get_node("SFX").playing = true
		_animate_gunshot()
		_spawn_bullet()
		_shake_camera()

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
	var rotation = fmod(self.rotation_degrees, 360)
	if rotation > 90 && rotation < 270: 
		get_node("Sprite").set_flip_v(true)
	else:
		get_node("Sprite").set_flip_v(false)

	if Input.is_action_pressed("shoot"):
		_on_shoot()

