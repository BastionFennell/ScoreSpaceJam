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

func _is_coordinate_valid(coord):
	var player = get_node("/root/World/Player")
	var playerX = player.global_position.x - 1100
	var playerY = player.global_position.y - 600

	var inXRange = coord.x > playerX && coord.x < playerX + 2200
	var inYRange = coord.x > playerY && coord.y < playerY + 1200

	if (inXRange && inYRange):
		return false

	return true


func _get_spawn_position():
	var y = randf() * (height - 2 * margin) - margin
	var x = randf() * (width - 2 * margin) - margin

	while !_is_coordinate_valid(Vector2(x, y)):
		y = randf() * (height - 2 * margin) - margin
		x = randf() * (width - 2 * margin) - margin

	return Vector2(x, y)



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

	if respawn_timer > 0.1:
		respawn_timer -= decay * randf()
		if respawn_timer < 0.1:
			respawn_timer = 0.1

func _process(delta):
	pass
