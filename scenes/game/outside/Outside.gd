extends Node2D


var Player = preload("res://scenes/game/characters/player/player.tscn")
var Camera = preload("res://scenes/Camera.tscn")

export (float) var round_length = 120.00

var player_info = {}
var time = 0;
var globals
var self_peer_id

func _ready():
	globals = get_node("/root/Globals")
	globals.time_stopped = false

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

func _process(delta):
	if !globals.time_stopped:
		time += delta
	
	if time > round_length && !globals.time_stopped:
		globals.stop_time()
		globals.transition_to("inner temple")


