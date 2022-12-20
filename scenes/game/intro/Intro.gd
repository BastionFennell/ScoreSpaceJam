extends Node2D

func _ready():
	var animator = get_node("Animator")
	animator.play("Intro")
	animator.connect("animation_finished", self, "_on_animation_finished")

func _on_animation_finished(_unused):
	_go_to_menu()

func _go_to_menu():
	get_tree().change_scene("res://scenes/game/menu/menu.tscn")

func _process(_delta):
	if Input.is_action_pressed("ui_cancel") || Input.is_action_pressed("ui_accept") || Input.is_action_pressed("shoot") || Input.is_action_pressed("shoot"):
		_go_to_menu()
