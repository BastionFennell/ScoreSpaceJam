extends Area2D

export (String) var destination = "nightmare"
export (String) var trigger = "bed_unlocked-midori"
var globals

var is_interactive = true

func _ready():
	globals = get_node("/root/Globals")

	is_interactive = globals.get_trigger(trigger)
	globals.connect("triggers_updated", self, "_on_triggers_updated")

func on_interact():
	if !globals.get_trigger("has_shotgun"):
		globals.get_main_node().get_node("Cutscene Manager").on_first_dive()
	else:
		globals.set_trigger("entered_midori_dream", true)
		globals.set_trigger("built-signs", true)
		if globals.networked:
			if self.is_network_master():
				globals.transition_to(destination)
		else:
			globals.transition_to(destination)

func _on_triggers_updated(updated_trigger, value):
	if updated_trigger == trigger:
		is_interactive = value
