extends Node2D

func _ready():
	$AnimationPlayer.play("animations")

func leave_twilight():
	get_node("/root/Globals").get_main_node().get_node("/Transition").transition_to("res://scenes/game/nightmare/Nightmare.tscn")
