extends CanvasLayer

func _ready():
	var button = get_node("./Retry")
	var player = get_node("/root/World/Player")

	button.connect("pressed", self, "_retry")
	player.connect("player_death", self, "_on_death")

func _on_death():
	self.visible = true

func _retry():
	get_tree().reload_current_scene()
