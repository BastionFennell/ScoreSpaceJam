extends AnimationPlayer

var scene

func _ready():
	self.play("Fade in")

func transition_to(to):
	scene = to
	get_tree().paused = true
	self.connect("animation_finished", self, "_on_animation_finished")
	self.play("Fade out")

func _on_animation_finished(name):
	if name == "Fade out":
		get_tree().paused = false
		get_node("/root/Globals").transition_to(scene)