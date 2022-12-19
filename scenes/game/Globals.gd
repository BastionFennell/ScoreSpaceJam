extends Node2D

signal inventory_updated
signal has_interacted
signal bought

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

var days = 0
var kills = 0
var has_interacted = false

func _ready():
	Engine.set_target_fps(Engine.get_iterations_per_second())

func reset():
	selling = default_selling.duplicate(true)
	upgrades = default_upgrades.duplicate(true)
	inventory = default_inventory.duplicate(true)

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
