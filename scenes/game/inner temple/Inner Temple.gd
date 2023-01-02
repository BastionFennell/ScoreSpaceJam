extends Node2D

var Player = preload("res://scenes/game/characters/player/player.tscn")
var Camera = preload("res://scenes/Camera.tscn")

var player_info = {}
var self_peer_id
var globals

func _ready():
	globals = get_node("/root/Globals")

	self_peer_id = globals.self_peer_id
	var my_player = Player.instance()
	my_player.set_network_master(self_peer_id)
	my_player.set_name(str(self_peer_id))
	
	var camera = Camera.instance()
	my_player.add_child(camera)

	globals.get_main_node().get_node("Players").add_child(my_player)

	globals.reset_players()

	for child in get_children():
		if child.has_method("connect_to_player"):
			child.connect_to_player(my_player)

		if child.has_method("setup"):
			child.setup()