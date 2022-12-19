extends Node2D

export (float) var spawn_rate = 0.2

var Stone = preload("res://scenes/game/resources/stone/Stone.tscn") 

var stone_height = 8
var stone_width = 12

func _ready():
	var area_node = get_node("Area2D")
	var origin = area_node.global_position
	var size = area_node.get_node("CollisionShape2D").shape.extents * 2

	var stone_x = 0
	var stone_y = 0

	while(stone_x < size.x):
		while(stone_y < size.y):
			if randf() <= spawn_rate:
				var node = Stone.instance()
				node.set_position(Vector2(origin.x + stone_x, origin.y + stone_y))

				get_node("/root/World").call_deferred("add_child", node)
			stone_y += stone_height
		stone_x += stone_width 
		stone_y = 0


