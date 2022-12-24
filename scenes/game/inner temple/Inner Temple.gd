extends Node2D

var Player = preload("res://scenes/game/characters/player/player.tscn")
export (int) var SERVER_PORT = 31337
export (int) var MAX_PLAYERS = 2
export (bool) var IS_CLIENT = true
export (String) var SERVER_IP = "127.0.0.1"

var player_info = {}
var self_peer_id
var globals

func _ready():
	globals = get_node("/root/Globals")
	get_tree().connect("network_peer_connected", self, "_player_connected")

	if IS_CLIENT:
		var peer = NetworkedMultiplayerENet.new()
		peer.create_client(SERVER_IP, SERVER_PORT)
		get_tree().network_peer = peer
	else:
		var peer = NetworkedMultiplayerENet.new()
		peer.create_server(SERVER_PORT, MAX_PLAYERS)
		get_tree().network_peer = peer

	self_peer_id =  get_tree().get_network_unique_id()
	globals.self_peer_id = self_peer_id
	var my_player = Player.instance()
	my_player.set_network_master(self_peer_id)
	my_player.set_name(str(self_peer_id))
	
	var camera = Camera2D.new()
	camera.zoom = Vector2(0.5, 0.5)
	camera.current = true
	my_player.add_child(camera)

	globals.get_main_node().get_node("Players").add_child(my_player)

	for child in get_children():
		if child.has_method("connect_to_player"):
			child.connect_to_player(my_player)

func _player_connected(player_id):
	print(player_id)

	var player = Player.instance()
	player.set_network_master(player_id)
	player.set_name(str(player_id))
	globals.get_main_node().get_node("Players").add_child(player)

remote func register_player(info):
	# Get the id of the RPC sender.
	var id = get_tree().get_rpc_sender_id()
	# Store the info
	player_info[id] = info
	print(player_info)
