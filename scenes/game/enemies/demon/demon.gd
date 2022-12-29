extends "res://scenes/game/enemies/enemy.gd"

var RifleSchematic = preload("res://scenes/game/drops/schematics/Rifle Schematic.tscn")

func _init():
	speed = 70
	health = 5
	drops = [RifleSchematic]
	weights = [100]
	damage = 5

	speed_inc = 5
	health_inc = 0
	damage_inc = 0