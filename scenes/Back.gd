extends Button

func _pressed():
	get_node("/root/Main/Options").visible = false

	get_node("/root/Main/Menu/Start Button").grab_focus()

func _process(_delta):
	if Input.is_action_just_pressed("ui_cancel"):
		_pressed()