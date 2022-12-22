extends Node2D


export (float) var round_length = 120.00

var time = 0;
var globals

func _ready():
	globals = get_node("/root/Globals")

func _process(delta):
	if !globals.time_stopped:
		time += delta
	
	if time > round_length && !globals.time_stopped:
		globals.stop_time()
		globals.get_main_node().get_node("Transition").transition_to("res://scenes/game/town/Twilight.tscn")


