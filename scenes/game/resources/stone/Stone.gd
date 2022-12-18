extends "res://scenes/game/enemies/enemy.gd"

var Stone = preload("res://scenes/game/drops/Stone/Stone.tscn")

func _ready():
	speed = 0
	drops = [Stone]
	weights = [100]