extends Node2D

var Enemy = preload("res://scenes/game/enemies/zombie/Zombie.tscn") 

export (float) var respawn_timer = 0.1
export (float) var decay = 0.01
export (float) var difficulty_timer = 1.00
export (float) var min_respawn_time = 0.01

var safe_radius = 150

func _ready():
	_spawn_enemy()

func _get_spawn_position():
	var player = get_node("/root/World/Player")

	var distance = randf() * 100 + safe_radius
	var direction = randf() * 2 * PI

	var center = Vector2(player.global_position.x, player.global_position.y)
	
	return center + Vector2(distance, 0).rotated(direction)

func _ramp_difficulty():
	if respawn_timer > min_respawn_time:
		respawn_timer -= decay * randf()
		if respawn_timer < min_respawn_time:
			respawn_timer = min_respawn_time

	var timer = Timer.new()
	timer.one_shot = true
	timer.wait_time = difficulty_timer
	timer.connect("timeout", self, "_ramp_difficulty") 
	add_child(timer)
	timer.start()

func _spawn_enemy():
	var coords = _get_spawn_position()

	var enemy = Enemy.instance();
	enemy.set_position(coords)
	get_node("/root/World").call_deferred("add_child", enemy)

	var timer = Timer.new()
	timer.one_shot = true
	timer.wait_time = respawn_timer
	timer.connect("timeout", self, "_spawn_enemy") 
	add_child(timer)
	timer.start()
