extends Node2D

puppet var puppet_rotation = 0

export (float) var damage = 5.0
export (float) var screen_shake = 0.3
export (float) var reload_multiplier = 1.0
export (float) var reload_buff_remaining = null
export (float) var damage_add = 0.0
export (float) var reload_speed_upgrade = 0.8
export (float) var damage_upgrade = 1.0
export (float) var lifetime = 0.6
export (float) var fire_delay = 0.5
export (float) var reload_time = 2.0
export (String) var bullet_type = "shotgun"
export (int) var max_ammo = 2
export (int) var speed = 100

var reloading = false
var is_fire_delay = false
var remaining_fire_delay = null
var remaining_reload_time = null
var spread = 8
var count = 10
var ammo
var world
var player
var parts

func _ready():
	player = get_parent()
	world = get_node("/root/Globals").get_main_node()
	var upgrades = get_node("/root/Globals").upgrades
	ammo = max_ammo

	reload_time *= pow(reload_speed_upgrade, upgrades.reload)
	damage_add += damage_upgrade * upgrades.damage

func setup_components():
	print(parts)

func get_damage():
	return damage + damage_add

func _spawn_single_bullet(rotation, position):
	if (player.should_broadcast()):
		for p in world.get_node("Players").get_children():
			p.rpc("shoot", rotation, position, get_damage(), speed, lifetime, bullet_type, get_network_master())
	else:
		get_parent().shoot(rotation, position, get_damage(), speed, lifetime, bullet_type, get_network_master())

func _spawn_bullet():
	var spawner = get_node('./Bullet Spawner')

	for i in count:
		_spawn_single_bullet(spawner.global_rotation + (randf() * spread - spread/2), spawner.global_position)

func _shake_camera():
	get_node("/root/Globals").get_player().get_node("Camera").add_trauma(screen_shake)

func _temp_speed_buff():
	reloading = false
	reload_multiplier = 0.1
	reload_buff_remaining = 1

func _damage_upgrade():
	damage_add = damage_add + damage_upgrade

func _speed_upgrade():
	reload_time *= reload_speed_upgrade

func _on_shoot():
	if (!reloading && !is_fire_delay):
		ammo -= 1
		if ammo <= 0:
			reloading = true
			remaining_reload_time = reload_time * reload_multiplier
		else:
			is_fire_delay = true
			remaining_fire_delay = fire_delay
		get_node("SFX").playing = true
		get_node("Gun").play("shoot")
		_spawn_bullet()
		_shake_camera()

func _reload():
	reloading = false

func network_tick():
	if player.should_broadcast():
		rset_unreliable("puppet_rotation", rotation)

func _process(delta):
	if(player.playing && player.in_control()):
		var controller_mode = get_node("/root/Globals").controller_mode

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

		if reloading:
			remaining_reload_time = remaining_reload_time - delta
			if remaining_reload_time <=0:
				reloading = false
				remaining_reload_time = null
				ammo = max_ammo
		elif is_fire_delay:
			remaining_fire_delay = remaining_fire_delay - delta
			if remaining_fire_delay <= 0:
				is_fire_delay = false
				remaining_fire_delay = null
		else:
			if Input.is_action_pressed("shoot"):
				_on_shoot()

		if reload_buff_remaining != null:
			var remaining = reload_buff_remaining - delta
			if  remaining <= 0:
				reload_multiplier = 1.0
				remaining = null
			reload_buff_remaining = remaining
	else:
		rotation = lerp_angle(rotation, puppet_rotation, delta * 8)
	
	var rotation = abs(fmod(self.rotation_degrees, 360))
	if rotation > 90 && rotation < 270: 
		get_node("Gun").set_flip_v(true)
	else:
		get_node("Gun").set_flip_v(false)
	
	network_tick()
