extends Node

# Called when the node enters the scene tree for the first time.
func _ready():
	pass
	
func _on_spawn_item(items, weights, node):
	var chance = 100 * randf()
	for i in weights.size():
		chance -= weights[i]
		if chance <= 0:
			var item = items[i].instance();
			item.set_position(node.position)
			get_node("/root/World").call_deferred("add_child", item)
			break
