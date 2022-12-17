extends CanvasLayer

func _ready():
	var button = get_node("./Retry")
	var player = get_node("/root/World/Player")

	button.connect("pressed", self, "_retry")
	player.connect("player_death", self, "_on_death")

func _parse_time(time):
	var seconds = int(time) % 60
	var minutes = int(time / 60)
	return "%d minutes and %d seconds" % [minutes, seconds]

func _on_death():
	var world = get_node("/root/World")
	world.stop_time()
	var time = _parse_time(world.time)
	get_node("Survived").text = "You survived for: " + time
	self.visible = true

func _retry():
	get_tree().reload_current_scene()
