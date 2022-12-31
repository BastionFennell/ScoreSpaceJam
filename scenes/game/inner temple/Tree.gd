extends "res://scenes/game/resources/Resource Base.gd"

var Wood = preload("res://scenes/game/drops/Wood/Wood.tscn")

func _ready():
	health = 10
	drops = [Wood]
	weights = [100]