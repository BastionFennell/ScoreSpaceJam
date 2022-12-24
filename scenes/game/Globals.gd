extends Node2D

signal inventory_updated
signal has_interacted
signal bought

var self_peer_id = 0

var controller_mode = false

var time_stopped = false

var bullet_types = {
	"shotgun": preload("res://scenes/game/weapons/Shotgun Bullet.tscn"),
	"axegun": preload("res://scenes/game/weapons/Axegun Bullet.tscn")
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

var default_inventory = {
	"wood": 0,
	"stone": 0
}
var inventory = default_inventory.duplicate(true)

# Gunsmithing
var parts_data = {
	"stock": {
		"price": 2
	},
	"barrel": {
		"price": 2
	}
}
var parts_inventory = {}
var unlocked_parts = ["stock", "barrel"]

var guns_data = {
	"shotgun": {
		"parts": {
			"stock": 1,
			"barrel": 2
		}
	}
}
var unlocked_guns = ["shotgun"]

var current_parts = []
var current_guns = []


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
	return get_node("/root").get_children()[1]

func get_player():
	return get_main_node().get_node("Players/%s" % self_peer_id)

func _process(_delta):
	if Input.is_action_pressed("controller_mode"):
		controller_mode = true
	if Input.is_action_pressed("non_controller_mode"):
		controller_mode = false

