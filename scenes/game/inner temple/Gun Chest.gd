extends Area2D

var is_interactive = true

func on_interact():
	get_parent().get_node("Gun Chest Screen").open()