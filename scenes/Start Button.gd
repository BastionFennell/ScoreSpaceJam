extends Button

func _ready():
	self.grab_focus()
	self.connect("focus_entered", self, "_on_focus_entered")

func _pressed():
	get_tree().change_scene("res://Twilight.tscn")

func _on_focus_entered():
	get_node("/root/Main/Menu Sound").play()
