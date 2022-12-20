extends AnimationPlayer

func _ready():
	self.play("Fade in")

	var world = get_node("/root/World")

	if world.has_signal("leave_twilight"):
		world.connect("leave_twilight", self, "_on_leave_twilight")
		self.connect("animation_finished", self, "_on_twilight_animation_finished")

	if world.has_signal("round_finished"):
		world.connect("round_finished", self, "_on_round_finished")
		self.connect("animation_finished", self, "_on_animation_finished")

func _on_round_finished():
	get_tree().paused = true
	self.play("Fade out")

func _on_animation_finished(name):
	if name == "Fade out":
		get_tree().paused = false
		get_tree().change_scene("res://scenes/game/town/Twilight.tscn")

func _on_leave_twilight():
	get_tree().paused = true
	self.play("Fade out")

func _on_twilight_animation_finished(name):
	if name == "Fade out":
		get_tree().paused = false
		get_tree().change_scene("res://scenes/game/nightmare/Nightmare.tscn")
