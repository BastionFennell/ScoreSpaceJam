extends Button

func _pressed():
	get_node("/root/Main/Menu").visible = true
	get_node("/root/Main/Options").visible = false