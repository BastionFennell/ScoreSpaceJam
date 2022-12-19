extends Node2D

export (float) var spawn_rate = 0.2

var Tree = preload("res://scenes/game/resources/tree/Tree.tscn") 

var tree_height = 15
var tree_width = 12

func _ready():
	var area_node = get_node("Area2D")
	var origin = area_node.global_position
	var size = area_node.get_node("CollisionShape2D").shape.extents * 2

	var tree_x = 0
	var tree_y = 0

	while(tree_x < size.x):
		while(tree_y < size.y):
			if randf() <= spawn_rate:
				var node = Tree.instance()
				node.set_position(Vector2(origin.x + tree_x, origin.y + tree_y))

				get_node("/root/World").call_deferred("add_child", node)
			tree_y += tree_height
		tree_x += tree_width 
		tree_y = 0


