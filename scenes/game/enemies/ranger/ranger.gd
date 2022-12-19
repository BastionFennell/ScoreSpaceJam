extends "res://scenes/game/enemies/enemy.gd"

var Heart = preload("res://scenes/game/drops/Heart/Health.tscn")
var jump_distance = 100
var jumping = false
var jumping_to

var winding_up = false
var wind_up_time = 0.3
var wound_up = 0

var is_pouncing = false
var pouncing = 0
var pouncing_time = 0.2

func _init():
	speed = 50
	health = 50
	drops = [Heart]
	weights = [10]
	damage = 25

	speed_inc = 5
	health_inc = 0
	damage_inc = 5

func _jump():
	jumping = true
	jumping_to = player.global_position
	winding_up = true

func _wind_up(delta):
	var norm = (jumping_to - self.global_position).normalized()
	var wind_up =  norm * 10

	move_and_slide(-wind_up - norm * speed )

func pounce(delta):
	var norm = (jumping_to - self.global_position)

	move_and_slide((norm / pouncing_time) * 3)

func _reset_pounce():
	wound_up = 0
	pouncing = 0
	jumping = false

func _process(delta):
	if winding_up:
		if wound_up < wind_up_time:
			wound_up += delta
			_wind_up(delta)
		else:
			winding_up = false
			is_pouncing = true

	if is_pouncing:
		if pouncing < pouncing_time:
			pouncing += delta
			pounce(delta)
		else:
			is_pouncing = false

			var timer = Timer.new()
			timer.one_shot = true
			timer.wait_time = 1.5 + .5 * randf()
			timer.connect("timeout", self, "_reset_pounce") 
			add_child(timer)
			timer.start()

	if self.global_position.distance_to(player.global_position) < jump_distance && !jumping:
		_jump()
