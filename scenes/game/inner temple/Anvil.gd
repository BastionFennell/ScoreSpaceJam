extends Area2D

var globals

var is_interactive = false

func _ready():
	globals = get_node("/root/Globals")

	is_interactive = globals.get_trigger("gunsmithing_unlocked")
	globals.connect("triggers_updated", self, "_on_triggers_updated")

func on_interact():
	get_parent().get_node("Gunsmithing").open()

func _on_triggers_updated(updated_trigger, value):
	if updated_trigger == "gunsmithing_unlocked":
		is_interactive = value