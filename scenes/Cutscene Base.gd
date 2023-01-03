extends NinePatchRect

var globals
var checkbox
var viewed

var cutscene = "intro"

func _ready():
	globals = get_node("/root/Globals")
	checkbox = get_node("CheckBox")
	viewed = globals.cutscenes[cutscene]

	checkbox.pressed = viewed
	checkbox.connect("pressed", self, "_on_check")

	get_node("Label").text = cutscene

func _on_check():
	viewed = !viewed
	checkbox.pressed = viewed
	globals.cutscenes[cutscene] = viewed