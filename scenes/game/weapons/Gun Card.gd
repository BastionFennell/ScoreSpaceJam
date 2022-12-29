extends TextureButton

var gun = {
	"name": "Shotgun",
	"reload_time": 0,
	"damage": 0,
	"count": 0
}

func _ready():
	get_node("Label").text = gun.name
	get_node("Damage/Amount").text = "%s" % gun.damage
	get_node("Reload/Amount").text = "%ss" % gun.reload_time
	get_node("Bullets/Amount").text = "%s" % gun.count
	self.connect("mouse_entered", self, "_on_mouse_entered")
	self.connect("mouse_exited", self, "_on_mouse_exited")

func _on_mouse_entered():
	if !self.disabled:
		$Hover.visible = true
		$Hover.animation = "hover"
		$Hover.play()

func _on_mouse_exited():
	$Hover.visible = false
	$Hover.animation = "default"