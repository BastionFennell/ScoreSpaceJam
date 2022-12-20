extends "res://scenes/game/enemies/enemy.gd"

var Heart = preload("res://scenes/game/drops/Heart/Health.tscn")

func _init():
	speed = 30
	health = 1
	drops = [Heart]
	weights = [10]
	damage = 10