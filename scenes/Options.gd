extends Button

func _pressed():
	get_node("/root/Main/Menu").visible = false
	get_node("/root/Main/Options").visible = true