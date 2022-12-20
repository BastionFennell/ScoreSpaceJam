extends Node2D


var controller_mode = false
var time = 0;
var time_stopped = false;

signal leave_twilight

func _ready():
	$AnimationPlayer.play("animations")

func stop_time():
	time_stopped = true

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_pressed("controller_mode"):
		controller_mode = true
	if Input.is_action_pressed("non_controller_mode"):
		controller_mode = false

	if !time_stopped:
		time += delta

func leave_twilight():
	emit_signal("leave_twilight")