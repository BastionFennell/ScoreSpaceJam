extends AnimatedSprite

func _ready():
	self.connect("animation_finished", self, "_on_animation_finished")

func _on_animation_finished():
	if self.animation != 'default':
		self.play('default')
