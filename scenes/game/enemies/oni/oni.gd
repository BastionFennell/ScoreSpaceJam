extends "res://scenes/game/enemies/enemy.gd"

var Heart = preload("res://scenes/game/drops/Heart/Health.tscn")
var Speed = preload("res://scenes/game/drops/ShotSpeed/ShotSpeed.tscn")

func _ready():
	speed = 10
	health = 100
	drops = [Heart]
	weights = [50]
	damage = 25