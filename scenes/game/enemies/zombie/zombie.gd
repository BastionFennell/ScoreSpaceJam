extends "res://scenes/game/enemies/enemy.gd"

var Heart = preload("res://scenes/game/drops/Heart/Health.tscn")
var ZombieArm = preload("res://scenes/game/drops/Zombie Arm/Zombie Arm.tscn")

func _init():
	speed = 30
	health = 1
	drops = [Heart, ZombieArm]
	weights = [10, 10]
	damage = 10