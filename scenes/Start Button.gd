extends Button

func _ready():
	self.grab_focus()

func _pressed():
	get_tree().change_scene("res://scenes/game/Twilight.tscn")
