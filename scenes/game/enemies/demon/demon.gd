extends "res://scenes/game/enemies/enemy.gd"

var Heart = preload("res://scenes/game/drops/Heart/Health.tscn")
var Speed = preload("res://scenes/game/drops/ShotSpeed/ShotSpeed.tscn")

func _init():
	speed = 70
	health = 5
	drops = [Speed]
	weights = [30]
	damage = 5

	speed_inc = 5
	health_inc = 0
	damage_inc = 0