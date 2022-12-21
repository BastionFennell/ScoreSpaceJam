extends "res://scenes/game/enemies/enemy.gd"

var Wood = preload("res://scenes/game/drops/Wood/Wood.tscn")

func _ready():
	health = 10
	speed = 0
	drops = [Wood]
	weights = [100]
	damage = 0