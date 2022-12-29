extends Node2D

var player

func connect_to_player(curr_player):
	player = curr_player

func _process(_delta):
	self.global_position = player.global_position
