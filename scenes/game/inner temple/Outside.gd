extends Area2D

var is_interactive = true
var globals

func _ready():
	globals = get_node("/root/Globals")
	is_interactive = !globals.has_gone_outside_today

func on_interact():
	globals.has_gone_outside_today = true
	globals.set_trigger("has_gone_outside", true)
	globals.transition_to("outside")