extends Node2D

signal inventory_updated
signal has_interacted
signal bought
signal triggers_updated

var self_peer_id = 0
export (int) var SERVER_PORT = 31337
export (int) var MAX_PLAYERS = 2
export (bool) var IS_CLIENT = true
export (String) var SERVER_IP = "127.0.0.1"
var Player = preload("res://scenes/game/characters/player/player.tscn")
var Debug = preload("res://scenes/Debug.tscn")
var networked = false
var player_list = []

var controller_mode = false

var time_stopped = false

var cutscenes = {
	"intro": true,
	"prophecy": false,
	"on_first_dive": false,
	"offer_to_fix": false
}

var _triggers = {
	"holy_tree_destroyed": false,
	"built-prophecy_chamber": false,
	"built-gunforge": false,
	"built-signs": false,
	"bed_unlocked-midori": false,
	"gunsmithing_unlocked": false,
	"yume_unlocked": false,
	"has_shotgun": false,
	"entered_midori_dream": false,
	"has_gone_outside": false
}

var zone_list = {
	"nightmare": "res://scenes/game/nightmare/Nightmare.tscn",
	"inner temple": "res://scenes/game/inner temple/Inner Temple.tscn",
	"outside": "res://scenes/game/outside/Outside.tscn"
}

var default_selling = {
	"health": {
		"price": {
			"wood": 1
		},
		"increase": 1,
		"upgrade": "health"
	},
	"reload": {
		"price": {
			"stone": 1,
			"wood": 1
		},
		"increase": 1,
		"upgrade": "reload"
	},
	"damage": {
		"price": {
			"stone": 1
		},
		"increase": 1,
		"upgrade": "damage"
	}
}
var selling = default_selling.duplicate(true)

var default_upgrades = {
	"damage": 0,
	"health": 0,
	"reload": 0
}
var upgrades = default_upgrades.duplicate(true)

var inventory_icons = {
	"wood": preload("res://assets/sprites/resources/wood.png"),
	"stone": preload("res://assets/sprites/resources/stone.png"),
	"zombie arm": preload("res://assets/sprites/resources/zombie arm.png"),
}
var default_inventory = {
	"wood": 100,
	"stone": 100,
	"zombie arm": 10
}
var inventory = default_inventory.duplicate(true) setget set_inventory

var days = 0
var kills = 0
var has_interacted = false

func _ready():
	Engine.set_target_fps(Engine.get_iterations_per_second())

func reset():
	selling = default_selling.duplicate(true)
	upgrades = default_upgrades.duplicate(true)
	inventory = default_inventory.duplicate(true)
	days = 0

func add_item(item, amount):
	var new_amount = inventory[item] + amount if inventory[item] else amount

	inventory[item] = new_amount
	emit_signal("inventory_updated")

func set_inventory(new_inventory):
	emit_signal("inventory_updated")

func get_trigger(trigger):
	return _triggers[trigger]

func set_trigger(trigger, value):
	_triggers[trigger] = value
	emit_signal("triggers_updated", trigger, value)

func on_first_interact():
	has_interacted = true
	emit_signal("has_interacted")

func on_buy(item):
	for i in selling[item].price:
		selling[item].price[i] += selling[item].increase
	emit_signal("bought", item, selling[item])
	emit_signal("inventory_updated")

func round_complete():
	days += 1

func stop_time():
	time_stopped = true

func get_main_node():
	return get_node("/root").get_children()[2]

func get_player():
	return get_main_node().get_node("Players/%s" % self_peer_id)

func can_afford(price):
	for p in price:
		if inventory[p] < price[p]:
			return false

	return true

func pay(price):
	# This assumes that you have already made sure the player can afford paying this price
	for p in price:
		inventory[p] -= price[p]

func _process(_delta):
	if Input.is_action_pressed("controller_mode"):
		controller_mode = true
	if Input.is_action_pressed("non_controller_mode"):
		controller_mode = false

	if Input.is_action_pressed("debug"):
		if !get_main_node().has_node("Debug"):
			var debug = Debug.instance()
			debug.name = "Debug"
			get_main_node().add_child(debug)



# Networking

func start_server():
	if networked:
		return

	get_tree().connect("network_peer_connected", self, "_player_connected")
	networked = true

	var peer = NetworkedMultiplayerENet.new()
	peer.create_server(SERVER_PORT, MAX_PLAYERS)
	get_tree().network_peer = peer
	
	var new_peer_id = get_tree().get_network_unique_id()
	var player = get_player()

	player.set_name(str(new_peer_id))
	player.set_network_master(new_peer_id)
	self_peer_id = new_peer_id

func connect_to_server(ip_address):
	if networked:
		return

	networked = true
	var peer = NetworkedMultiplayerENet.new()
	peer.create_client(ip_address, SERVER_PORT)
	get_tree().network_peer = peer

	var new_peer_id = get_tree().get_network_unique_id()
	var player = get_player()

	player.set_name(str(new_peer_id))
	player.set_network_master(new_peer_id)
	self_peer_id = new_peer_id

	player_list = [1]

func get_player_data():
	var data = {}
	var player_list = get_main_node().get_node("Players").get_children()
	for p in player_list:
		data[p.name] = {
			"position": {
				"x": p.global_position.x,
				"y": p.global_position.y
			}
		}

	return data

func _player_connected(player_id):
	rpc_id(player_id, "set_players", get_player_data())

	var player = Player.instance()
	player.set_network_master(player_id)
	player.set_name(str(player_id))
	player.pause_mode = Node.PAUSE_MODE_PROCESS
	get_main_node().get_node("Players").add_child(player)
	player_list.append(player_id)

remote func set_players(players):
	for p in players:
		var current_player = Player.instance();
		current_player.global_position.x = players[p].position.x
		current_player.global_position.y = players[p].position.y
		current_player.set_name(p)
		current_player.pause_mode = Node.PAUSE_MODE_PROCESS
		get_player().get_parent().add_child(current_player)

remotesync func reset_players():
	for p in player_list:
		if p != self_peer_id:
			var current_player = Player.instance();
			current_player.global_position.x = 0
			current_player.global_position.y = 0
			current_player.set_name(str(p))
			current_player.pause_mode = Node.PAUSE_MODE_PROCESS
			current_player.set_network_master(p)
			get_main_node().get_node("Players").add_child(current_player)

mastersync func transition_to(zone):
	if get_main_node().has_node("Transition"):
		get_main_node().get_node("Transition").transition_to(zone_list[zone])
	else:
		get_tree().change_scene(zone_list[zone])

	if networked:
		rpc("on_transition_to", zone)

puppetsync func on_transition_to(zone):
	get_tree().change_scene(zone_list[zone])
