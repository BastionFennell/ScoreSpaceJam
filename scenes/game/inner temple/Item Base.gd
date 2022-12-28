extends ColorRect

var item = "wood"
var draggable = true
var globals

func _ready():
	globals = get_node("/root/Globals")
	if globals.inventory[item] == 0:
		draggable = false
		self.mouse_default_cursor_shape = CURSOR_FORBIDDEN
	

func get_drag_data(position):
	if !draggable:
		return null

	var drag_preview = self.duplicate()
	set_drag_preview(drag_preview)
	return item

func can_drop_data(position, data):
	return true

func drop_data(_position, data):
	print("Droppin")
