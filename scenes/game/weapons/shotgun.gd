extends "res://scenes/game/weapons/Gun.gd"

func _ready():
	reload_time = 2
	spread = 10
	screen_shake = 0.3

	Bullet = preload("res://scenes/game/weapons/Shotgun Bullet.tscn")
