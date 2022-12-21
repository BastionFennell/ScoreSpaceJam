extends "../Resource Spawner.gd"

func _init():
	items = {
		"stone": {
			"spawn_rate": 0.2,
			"node": preload("res://scenes/game/resources/stone/Stone.tscn")
		}
	}
	height = 8
	width = 12