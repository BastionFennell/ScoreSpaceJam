extends "res://scenes/game/enemies/enemy.gd"

var Heart = preload("res://scenes/game/drops/Heart/Health.tscn")
var Speed = preload("res://scenes/game/drops/ShotSpeed/ShotSpeed.tscn")

func _ready():
	speed = 30
	health = 5
	drops = [Heart, Speed]
	weights = [10, 80]
	damage = 10