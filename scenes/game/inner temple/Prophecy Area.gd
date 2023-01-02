extends Area2D

var globals

var scroll_is_open = false
var is_interactive = true

func _ready():
	globals = get_node("/root/Globals")
	get_node("../Animator").connect("animation_finished", self, "_on_anim_finished")

func on_interact():
	if !scroll_is_open:
		scroll_is_open = true
		get_tree().paused = true
		get_node("../Animator").play("Open Scroll")

func _process(_delta):
	if scroll_is_open:
		if Input.is_action_just_pressed("ui_accept") || Input.is_action_just_pressed("shoot") || Input.is_action_just_pressed("ui_cancel"):
			get_tree().paused = false
			get_node("../Animator").play("Close Scroll")
			if !globals.cutscenes.prophecy:
				globals.get_main_node().get_node("Cutscene Manager").on_prophecy_read()

func _on_anim_finished(anim):
	if anim == "Close Scroll":
		scroll_is_open = false
