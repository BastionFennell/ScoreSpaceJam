extends "res://scenes/game/enemies/enemy.gd"

var Heart = preload("res://scenes/game/drops/Heart/Health.tscn")

export (int) var margin = 10

func _init():
	speed = 10
	health = 100
	drops = [Heart]
	weights = [50]
	damage = 25

	speed_inc = 0
	health_inc = 50
	damage_inc = 5

func _process(delta):
	var safe_radius = get_node("/root/Globals").get_main_node().get_node("/EnemySpawner").safe_radius

	if self.global_position.distance_to(player.global_position) > safe_radius:
		var x_diff = player.global_position.x - self.global_position.x
		var x_margin = 10 if x_diff < 0 else -10
		self.global_position.x = self.global_position.x + x_diff * 2 + x_margin

		var y_diff = player.global_position.y - self.global_position.y
		var y_margin = 10 if y_diff < 0 else -10
		self.global_position.y = self.global_position.y + y_diff * 2 + y_margin
