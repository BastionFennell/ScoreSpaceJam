extends "res://scenes/game/weapons/Gun.gd"

func _init():
	reload_time = 2
	spread = 0.5
	screen_shake = 0.3
	count = 10

	Bullet = preload("res://scenes/game/weapons/Shotgun Bullet.tscn")
