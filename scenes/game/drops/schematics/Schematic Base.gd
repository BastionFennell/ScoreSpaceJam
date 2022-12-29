extends "../Drop Base.gd"
export (String) var new_gun = "shotgun"

func _ready():
	if !get_node("/root/GunManager").unlocked_guns[new_gun]:
		self.visible = true
	else:
		queue_free()

func _pickUp():
	get_node("/root/GunManager").unlocked_guns[new_gun] = true
