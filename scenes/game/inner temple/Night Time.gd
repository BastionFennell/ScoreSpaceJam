extends CanvasModulate

func _ready():
	self.visible = get_node("/root/Globals").has_gone_outside_today
	pass # Replace with function body.
