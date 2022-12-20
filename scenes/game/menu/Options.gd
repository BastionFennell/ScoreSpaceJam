extends Button

func _ready():
	self.connect("focus_entered", self, "_on_focus_entered")

func _pressed():
	get_node("/root/Main/Options").visible = true

	get_node("/root/Main/Options/Volume Sliders/Main Volume Section/Volume Slider").grab_focus()

func _on_focus_entered():
	get_node("/root/Main/Menu Sound").play()
