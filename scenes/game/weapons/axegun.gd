extends "res://scenes/game/weapons/Gun.gd"

func _ready():
	reload_time = 1
	spread = 0
	screen_shake = 0.4
	count = 1

	Bullet = preload("res://scenes/game/weapons/Axegun Bullet.tscn")
