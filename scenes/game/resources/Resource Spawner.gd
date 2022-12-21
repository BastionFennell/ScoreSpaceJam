extends Node2D

var items = {
	"test item": {
		"spawn_rate": 0,
		"node": preload("res://scenes/game/resources/stone/Stone.tscn")
	}
}

var width = 12
var height = 15

var Stone = preload("res://scenes/game/resources/stone/Stone.tscn") 

var stone_height = 8
var stone_width = 12

func _ready():
	var area_node = get_node("Area2D")
	var origin = area_node.global_position
	var size = area_node.get_node("CollisionShape2D").shape.extents * 2

	var spawn_x = 0
	var spawn_y = 0

	while(spawn_x < size.x):
		while(spawn_y < size.y):
			var rand = randf()
			var spawned = false
			for i in items:
				var item = items[i]
				if randf() <= item.spawn_rate && !spawned:
					var node = item.node.instance()
					node.set_position(Vector2(origin.x + spawn_x, origin.y + spawn_y))

					get_node("/root/Globals").get_main_node().call_deferred("add_child", node)
					spawned = true
				else:
					rand -= item.spawn_rate

				spawn_y += height
		spawn_x += stone_width 
		spawn_y = 0


