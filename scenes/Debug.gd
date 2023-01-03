extends CanvasLayer

var globals
var triggers_list
var cutscenes_list

func _ready():
	globals = get_node("/root/Globals")
	triggers_list = get_node("Triggers Container/Triggers")
	cutscenes_list = get_node("Cutscenes Container/Cutscenes")

	_setup_triggers()
	_setup_cutscenes()

func _setup_triggers():
	var base = get_node("Trigger Base")

	if triggers_list.get_children():
		for c in triggers_list.get_children():
			triggers_list.remove_node(c)
			c.queue_free()

	for t in globals._triggers:
		var node = base.duplicate()
		node.visible = true
		node.trigger = t
		node.triggered = globals._triggers[t]

		triggers_list.add_child(node)

func _setup_cutscenes():
	var base = get_node("Cutscene Base")

	if cutscenes_list.get_children():
		for c in cutscenes_list.get_children():
			cutscenes_list.remove_node(c)
			c.queue_free()

	for c in globals.cutscenes:
		var node = base.duplicate()
		node.visible = true
		node.cutscene = c
		node.viewed = globals.cutscenes[c]

		cutscenes_list.add_child(node)

func _process(_delta):
	if Input.is_action_just_pressed("ui_cancel"):
		get_parent().remove_child(self)
		self.queue_free()
