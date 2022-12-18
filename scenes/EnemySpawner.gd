extends Node2D

var safe_radius = 150
var enemies = {
	"zombie": { 
		"node": preload("res://scenes/game/enemies/zombie/Zombie.tscn"),
		"delay": 0,
		"respawn_timer": 0.1,
		"decay": 0.01,
		"difficulty_timer": 1.00,
		"min_respawn_time": 0.01
	},
	"demon": {
		"node": preload("res://scenes/game/enemies/demon/Demon.tscn"),
		"delay": 30,
		"respawn_timer": 1,
		"decay": 0.1,
		"difficulty_timer": 1.00,
		"min_respawn_time": 0.1
	}
}

func _ready():
	for i in enemies:
		var enemy = enemies[i];
		var timer = Timer.new()
		timer.one_shot = true
		timer.wait_time = enemy.delay
		timer.connect("timeout", self, "_spawn_enemy", [i]) 
		add_child(timer)
		timer.start()

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
	var difficulty_timer = enemy.difficulty_timer

	if enemies[enemy_type].respawn_timer > min_respawn_time:
		enemies[enemy_type].respawn_timer -= decay * randf()
		if enemies[enemy_type].respawn_timer < min_respawn_time:
			enemies[enemy_type].respawn_timer = min_respawn_time

	var timer = Timer.new()
	timer.one_shot = true
	timer.wait_time = difficulty_timer
	timer.connect("timeout", self, "_ramp_difficulty", [enemy_type]) 
	add_child(timer)
	timer.start()

func _spawn_enemy(enemy_type):
	var coords = _get_spawn_position()

	var enemy = enemies[enemy_type].node.instance();
	enemy.set_position(coords)
	get_node("/root/World").call_deferred("add_child", enemy)

	var timer = Timer.new()
	timer.one_shot = true
	timer.wait_time = enemies[enemy_type].respawn_timer
	timer.connect("timeout", self, "_spawn_enemy", [enemy_type]) 
	add_child(timer)
	timer.start()
