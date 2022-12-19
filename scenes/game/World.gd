extends Node2D

var controller_mode = false
var time = 0;
var time_stopped = false;

func _ready():
	get_node("/root/World/Player").set_health()

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