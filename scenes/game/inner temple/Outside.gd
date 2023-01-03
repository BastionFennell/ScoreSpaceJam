extends Area2D

var is_interactive = true

func on_interact():
	get_node("/root/Globals").set_trigger("has_gone_outside", true)
	get_node("/root/Globals").transition_to("outside")