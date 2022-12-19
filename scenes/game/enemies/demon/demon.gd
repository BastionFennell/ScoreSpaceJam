extends "res://scenes/game/enemies/enemy.gd"

var Heart = preload("res://scenes/game/drops/Heart/Health.tscn")
var Speed = preload("res://scenes/game/drops/ShotSpeed/ShotSpeed.tscn")

func _ready():
	speed = 50
	health = 5
	drops = [Speed]
	weights = [30]
	damage = 5