extends Area2D

var globals

var is_interactive = true

func _ready():
	globals = get_node("/root/Globals")

	is_interactive = globals.get_trigger("yume_unlocked")
	globals.connect("triggers_updated", self, "_on_triggers_updated")

func on_interact():
	if !globals.get_trigger("has_shotgun"):
		globals.get_main_node().get_node("Cutscene Manager").on_first_yume_interaction()

func _on_triggers_updated(updated_trigger, value):
	if updated_trigger == "yume_unlocked":
		is_interactive = value