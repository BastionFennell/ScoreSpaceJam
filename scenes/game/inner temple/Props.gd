extends YSort

func _ready():
	var globals = get_node("/root/Globals")	
	if globals.get_trigger("holy_tree_destroyed"):
		get_node("Holy Tree").visible = false
	else:
		get_node("Holy Tree").visible = true

	if globals.get_trigger("built-prophecy_chamber"):
		get_node("Prophecy Stand").modulate = "#ffffffff"
		get_node("Prophecy Stand").visible = true
		get_node("Prophecy Stand/Prophecy Area/Collider").disabled = false
		get_node("Prophecy Stand/Prophecy Wall/Collider").disabled = false
	else:
		get_node("Prophecy Stand").visible = false
		get_node("Prophecy Stand").modulate = "#ffffff00"
		get_node("Prophecy Stand/Prophecy Area/Collider").disabled = true
		get_node("Prophecy Stand/Prophecy Wall/Collider").disabled = true
