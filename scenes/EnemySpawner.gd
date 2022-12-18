extends Node2D

var Enemy = preload("res://scenes/game/enemies/zombie/Zombie.tscn") 

export (int) var margin = 50
export (float) var respawn_timer = 10.00
export (float) var decay = 1.00

var safe_radius = 150

func _ready():
	_spawn_enemy()

func _get_spawn_position():
	var player = get_node("/root/World/Player")

	var distance = randf() * 100 + safe_radius
	var direction = randf() * 2 * PI

	var center = Vector2(player.global_position.x, player.global_position.y)
	
	return center + Vector2(distance, 0).rotated(direction)

func _spawn_enemy():
	var coords = _get_spawn_position()
	print(coords)

	var enemy = Enemy.instance();
	enemy.set_position(coords)
	get_node("/root/World").call_deferred("add_child", enemy)

	var timer = Timer.new()
	timer.one_shot = true
	timer.wait_time = respawn_timer
	timer.connect("timeout", self, "_spawn_enemy") 
	add_child(timer)
	timer.start()

	if respawn_timer > 0.1:
		respawn_timer -= decay * randf()
		if respawn_timer < 0.1:
			respawn_timer = 0.1
