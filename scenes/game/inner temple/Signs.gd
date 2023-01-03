extends YSort

var globals

func _ready():
	globals = get_node("/root/Globals")

	self.visible = globals.get_trigger("built-signs")
	globals.connect("triggers_updated", self, "_on_triggers_updated")

func _on_triggers_updated(updated_trigger, value):
	if updated_trigger == "built-signs":
		self.visible = globals.get_trigger("built-signs")