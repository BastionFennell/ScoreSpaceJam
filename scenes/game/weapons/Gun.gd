extends KinematicBody2D

export (float) var screen_shake = 0.3
export (float) var reload_multiplier = 1.0
export (float) var reload_buff_remaining = null
export (float) var damage_add = 0.0
export var reloading = false

var remaining_reload_time = null
var reload_time = 2
var spread = 8
var count = 10

var Bullet = preload("res://scenes/game/weapons/Shotgun Bullet.tscn") 
	
func _spawn_single_bullet(rotation, position):
	var bullet = Bullet.instance()
	bullet.damage = bullet.damage + damage_add

	bullet.set_rotation(rotation)
	bullet.set_position(position)

	get_node('/root/World').add_child(bullet)

func _spawn_bullet():
	var spawner = get_node('./Bullet Spawner')

	for i in count:
		_spawn_single_bullet(spawner.global_rotation + (randf() * spread - spread/2), spawner.global_position)

func _shake_camera():
	get_node("/root/World/Player/Camera2D").add_trauma(screen_shake)

func _temp_speed_buff():
	reloading = false
	reload_multiplier = 0.1
	reload_buff_remaining = 1

func _on_shoot():
	if (!reloading):
		reloading = true
		get_node("SFX").playing = true
		get_node("Gun").play("shoot")
		_spawn_bullet()
		_shake_camera()

		remaining_reload_time = reload_time * reload_multiplier

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
	
	if reloading:
		remaining_reload_time = remaining_reload_time - _delta
		if remaining_reload_time <=0:
			reloading = false
			remaining_reload_time = null
	else:
		if Input.is_action_pressed("shoot"):
			_on_shoot()

	if reload_buff_remaining != null:
		var remaining = reload_buff_remaining - _delta
		if  remaining <= 0:
			reload_multiplier = 1.0
			remaining = null
		reload_buff_remaining = remaining

