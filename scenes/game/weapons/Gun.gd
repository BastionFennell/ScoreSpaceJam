extends KinematicBody2D

export (int) var reload_time = 2
export (int) var spread = 8
export (float) var screen_shake = 0.3
export (int) var count = 10

var Bullet = preload("res://scenes/game/weapons/Shotgun Bullet.tscn") 
var reloading = false
	
func _spawn_single_bullet(rotation, position):
	var bullet = Bullet.instance()

	bullet.set_rotation(rotation)
	bullet.set_position(position)

	get_node('/root/World').add_child(bullet)

func _spawn_bullet():
	var spawner = get_node('./Bullet Spawner')

	for i in count:
		_spawn_single_bullet(spawner.global_rotation + (randf() * spread - spread/2), spawner.global_position)

func _shake_camera():
	get_node("/root/World/Player/Camera2D").add_trauma(screen_shake)

func _on_shoot():
	if (!reloading):
		reloading = true
		get_node("SFX").playing = true
		get_node("Gun").play("shoot")
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
	var controller_mode = get_node("/root/World/").controller_mode

	if !controller_mode:
		look_at(get_global_mouse_position())
	else:
		var deadzone = 0.1
		var controllerangle = Vector2.ZERO
		var xAxisRL = Input.get_joy_axis(0, JOY_AXIS_2)
		var yAxisUD = Input.get_joy_axis(0 ,JOY_AXIS_3)

		if abs(xAxisRL) > deadzone || abs(yAxisUD) > deadzone:
			controllerangle = Vector2(xAxisRL, yAxisUD).angle()
			self.rotation = controllerangle

	var rotation = abs(fmod(self.rotation_degrees, 360))
	if rotation > 90 && rotation < 270: 
		get_node("Gun").set_flip_v(true)
	else:
		get_node("Gun").set_flip_v(false)

	if Input.is_action_pressed("shoot"):
		_on_shoot()

