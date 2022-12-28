extends ColorRect

var globals

signal part_selected

func _ready():
	globals = get_node("/root/Globals")

func can_drop_data(position, data):
	return true

func drop_data(_position, data):
	var icon = globals.inventory_icons[data]
	get_node("Sprite").texture = icon

	emit_signal("part_selected", data)