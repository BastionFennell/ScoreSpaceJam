extends "res://scenes/game/enemies/enemy.gd"

var Heart = preload("res://scenes/game/drops/Heart/Health.tscn")
var Speed = preload("res://scenes/game/drops/ShotSpeed/ShotSpeed.tscn")

func _ready():
	speed = 30
	health = 5
	drops = [Heart, Speed]
	weights = [10, 80]
	damage = 10
	respawn_timer = 0.1
	decay = 0.01
	difficulty_timer = 1.00
	min_respawn_time = 0.01