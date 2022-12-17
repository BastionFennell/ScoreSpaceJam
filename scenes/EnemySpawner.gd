extends Node2D

var Enemy = preload("res://scenes/game/enemies/zombie/Zombie.tscn") 

export (int) var margin = 50
export (float) var respawn_timer = 10
export (float) var decay = 1

signal spawn_enemy

var height = 0;
var width = 0;

func _ready():
	var bg = get_node("/root/World/Background")

	height = bg.get_rect().size.x * bg.scale.x
	width = bg.get_rect().size.y * bg.scale.y

	_spawn_enemy()

func _spawn_enemy():
	var y = randf() * (height - 2 * margin) - margin
	var x = randf() * (width - 2 * margin) - margin

	var enemy = Enemy.instance();
	enemy.set_position(Vector2(x, y))
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

func _process(delta):
	pass
