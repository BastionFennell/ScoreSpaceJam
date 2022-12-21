extends "../Drop Base.gd"

func _pickUp():
	player._on_damage(-5)
