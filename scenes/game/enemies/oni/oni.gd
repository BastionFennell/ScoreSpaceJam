extends "res://scenes/game/enemies/enemy.gd"

var Heart = preload("res://scenes/game/drops/Heart/Health.tscn")

func _init():
	speed = 10
	health = 100
	drops = [Heart]
	weights = [50]
	damage = 25

	speed_inc = 0
	health_inc = 50
	damage_inc = 5