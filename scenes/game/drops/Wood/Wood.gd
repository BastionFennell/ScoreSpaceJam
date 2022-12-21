extends "../Drop Base.gd"

func _pickUp():
	get_node("/root/Globals").add_item("wood", 1)