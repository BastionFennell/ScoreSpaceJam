extends Node2D

var controller_mode = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_pressed("controller_mode"):
		controller_mode = true
	if Input.is_action_pressed("non_controller_mode"):
		controller_mode = false
