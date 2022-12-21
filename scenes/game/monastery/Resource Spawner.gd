extends "res://scenes/game/resources/Resource Spawner.gd"

func _init():
	items = {
		"tree": {
			"spawn_rate": 0.2,
			"node": preload("res://scenes/game/resources/tree/Tree.tscn")
		},
		"stone": {
			"spawn_rate": 0.2,
			"node": preload("res://scenes/game/resources/stone/Stone.tscn")
		}
	}

	height = 15
	width = 12