extends NinePatchRect

var globals
var checkbox
var triggered

var trigger = "holy_tree_destroyed"

func _ready():
	globals = get_node("/root/Globals")
	checkbox = get_node("CheckBox")
	triggered = globals.get_trigger(trigger)

	checkbox.pressed = triggered
	checkbox.connect("pressed", self, "_on_check")

	get_node("Label").text = trigger

func _on_check():
	triggered = !triggered
	checkbox.pressed = triggered
	globals.set_trigger(trigger, triggered)
