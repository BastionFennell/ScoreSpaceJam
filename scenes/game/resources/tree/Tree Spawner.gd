extends "../Resource Spawner.gd"

func _init():
	items = {
		"tree": {
			"spawn_rate": 0.2,
			"node": preload("res://scenes/game/resources/tree/Tree.tscn")
		}
	}
	height = 15
	width = 12