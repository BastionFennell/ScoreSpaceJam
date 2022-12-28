extends KinematicBody2D

puppet var puppet_position = Vector2(0, 0) setget puppet_position_set
puppet var puppet_velocity = Vector2(0, 0) setget puppet_velocity_set

var tween
var globals
var gun_man
var world

export (int) var speed = 1000
export (float) var health = 100.00
export (int) var health_upgrade = 10
export (float) var dash_time = 0.0
export (float) var dash_cooldown = 1.00
export (int) var dash_speed = 200

signal health_change
signal player_death 

var velocity = Vector2()
var touching = 0;
var playing = true;
var invincible = false

var is_dashing = false
var can_dash = true
var dash_direction

var current_gun = preload("res://scenes/game/weapons/Shotgun.tscn")

func _ready():
	globals = get_node("/root/Globals")
	gun_man = get_node("/root/GunManager")
	world = globals.get_main_node()
	tween = get_node("Tween")
	get_node("AnimationPlayer").connect("animation_finished", self, "_on_animation_finished")
	invincible = false
	set_health()

	gun_man.connect("change_current_gun", self, "update_gun")

	update_gun()

func get_gun():
	return get_node("Gun").get_child(0)

func update_gun():
	if has_node("Gun"):
		var old_gun = get_node("Gun")
		self.remove_child(old_gun)
		old_gun.queue_free()

	current_gun = gun_man.current_guns[gun_man.current_gun]
	var gun_node = gun_man.gun_types[current_gun.type].instance()
	gun_node.set_network_master(get_network_master())
	gun_node.name = "Gun"
	gun_node.parts = current_gun.parts
	gun_node.setup_components()

	call_deferred("add_child", gun_node)

func set_health():
	var upgrades = get_node("/root/Globals").upgrades

	health += health_upgrade * upgrades.health

func get_input_vector():
	var vec = Vector2()

	if Input.is_action_pressed("ui_right"):
		vec.x += Input.get_action_strength("ui_right")
	if Input.is_action_pressed("ui_left"):
		vec.x -= Input.get_action_strength("ui_left")
	if Input.is_action_pressed("ui_up"):
		vec.y -= Input.get_action_strength("ui_up")
	if Input.is_action_pressed("ui_down"):
		vec.y += Input.get_action_strength("ui_down")

	return vec.normalized()

func get_input():
	velocity = 	get_input_vector()
	velocity = velocity * speed

func _on_damage(damage):
	if(playing && !invincible):
		health -= damage
		if (health <= 0):
			emit_signal("player_death")
			playing = false
		else:
			emit_signal("health_change", floor(health));

func dash():
	can_dash = false
	dash_direction = get_input_vector()
	invincible = true
	is_dashing = true

	get_node("AnimationPlayer").play("Dash")

func _on_animation_finished(animation):
	if animation == "Dash":
		invincible = false
		is_dashing = false
		dash_time = 0

		var timer = Timer.new()
		timer.one_shot = true
		timer.wait_time = dash_cooldown
		timer.connect("timeout", self, "_refresh_dash") 
		add_child(timer)
		timer.start()

func _refresh_dash():
	$"Effect Player".play("Dash Refresh")
	can_dash = true

func puppet_position_set(pos):
	# We could be smarter about the sanity check here. Ideally we'd have a timer and if someone is
	# sending updated positions but is out of bounds for x seconds we just update their position
	if puppet_position != pos && puppet_position.distance_to(pos) < 500:
		puppet_position = pos
		tween.interpolate_property(self, "global_position", global_position, puppet_position, 0.1)
		tween.start()

func puppet_velocity_set(vel):
	# We could be smarter about the sanity check here. Ideally we'd have a timer and if someone is
	# sending updated positions but is out of bounds for x seconds we just update their position
	if abs(vel.x) < 500 && abs(vel.y) < 500:
		puppet_velocity = vel

func network_tick():
	if should_broadcast():
		rset_unreliable("puppet_position", global_position)
		rset_unreliable("puppet_velocity", velocity)

func is_master():
	return get_tree().network_peer && is_network_master()

func should_broadcast():
	if !globals.networked:
		return false
	else:
		return is_master()

func in_control():
	if !globals.networked:
		return true
	else:
		return is_master()

remotesync func shoot(rotation, position, damage, bullet_type, master_id):
	var bullet = gun_man.bullet_types[bullet_type].instance()

	bullet.damage = damage
	bullet.set_network_master(master_id)
	bullet.set_rotation(rotation)
	bullet.set_position(position)
	if globals.networked:
		bullet.pause_mode = Node.PAUSE_MODE_PROCESS

	world.add_child(bullet)

func _physics_process(delta):
	if(playing && in_control()):
		get_input()

		if Input.is_action_just_pressed("dash") && can_dash:
			dash()
			velocity += dash_direction * dash_speed
		elif is_dashing:
			dash_time += delta
			velocity += dash_direction * dash_speed * pow((1 - dash_time * 2), 3)

		velocity = move_and_slide(velocity)
		if !is_dashing:
			if velocity.x or velocity.y != 0:
				$AnimationPlayer.play("walking")
			else:
				$Sprite.frame = 0
		
			if(velocity.x < 0):
				$Sprite.flip_h = true
			elif(velocity.x > 0):
				$Sprite.flip_h = false
	else:
		if !tween.is_active():
			move_and_slide(puppet_velocity * speed)

		if tween.is_active() or puppet_velocity.x != 0 or puppet_velocity.y != 0:
			$AnimationPlayer.play("walking")
		else:
			$Sprite.frame = 0
		
		if(puppet_velocity.x < 0):
			$Sprite.flip_h = true
		elif(puppet_velocity.x > 0):
			$Sprite.flip_h = false

	network_tick()
