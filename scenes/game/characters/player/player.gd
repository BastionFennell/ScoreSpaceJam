extends KinematicBody2D

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

func _ready():
	get_node("AnimationPlayer").connect("animation_finished", self, "_on_animation_finished")
	invincible = false
	set_health()

func get_gun():
	return get_node("Gun").get_child(0)

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

func _process(delta):
	if(playing):
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
				$Thomas.frame = 0
		
			if(velocity.x < 0):
				$Thomas.flip_h = true
			elif(velocity.x > 0):
				$Thomas.flip_h = false
