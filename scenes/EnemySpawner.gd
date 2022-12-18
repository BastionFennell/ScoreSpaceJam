extends Node2D

var Zombie = preload("res://scenes/game/enemies/zombie/Zombie.tscn") 

var safe_radius = 150
var enemies = { "zombie": Zombie }

func _ready():
	_spawn_enemy("zombie")

func _get_spawn_position():
	var player = get_node("/root/World/Player")

	var distance = randf() * 100 + safe_radius
	var direction = randf() * 2 * PI

	var center = Vector2(player.global_position.x, player.global_position.y)
	
	return center + Vector2(distance, 0).rotated(direction)

func _ramp_difficulty(enemy_type):
	var enemy = enemies[enemy_type];
	var min_respawn_time = enemy.min_respawn_time
	var decay = enemy.decay
	var respawn_timer = enemy.respawn_timer
	var difficulty_timer = enemy.difficulty_timer

	if respawn_timer > min_respawn_time:
		respawn_timer -= decay * randf()
		if respawn_timer < min_respawn_time:
			respawn_timer = min_respawn_time

	var timer = Timer.new()
	timer.one_shot = true
	timer.wait_time = difficulty_timer
	timer.connect("timeout", self, "_ramp_difficulty", [enemy_type]) 
	add_child(timer)
	timer.start()

func _spawn_enemy(enemy_type):
	var coords = _get_spawn_position()

	var enemy = enemies[enemy_type].instance();
	enemy.set_position(coords)
	get_node("/root/World").call_deferred("add_child", enemy)

	var timer = Timer.new()
	timer.one_shot = true
	timer.wait_time = enemy.respawn_timer
	timer.connect("timeout", self, "_spawn_enemy", [enemy_type]) 
	add_child(timer)
	timer.start()
