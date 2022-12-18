extends "res://scenes/game/weapons/Gun.gd"

func _ready():
	reload_time = 2
	spread = 1
	screen_shake = 0.4

	Bullet = preload("res://scenes/game/weapons/Axegun Bullet.tscn")
