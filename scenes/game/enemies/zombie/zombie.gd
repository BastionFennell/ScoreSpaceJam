extends "res://scenes/game/enemies/enemy.gd"

var Heart = preload("res://scenes/game/drops/Heart/Health.tscn")

func _init():
	speed = 30
	health = 5
	drops = [Heart]
	weights = [10]
	damage = 10

	speed_inc = 5
	health_inc = 0
	damage_inc = 5
