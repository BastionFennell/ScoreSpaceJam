extends Button

func _pressed():
	get_node("/root/Main/Options").visible = true

	get_node("/root/Main/Options/Volume Sliders/Main Volume Section/Volume Slider").grab_focus()