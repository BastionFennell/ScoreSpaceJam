extends Node2D

signal inventory_updated
signal has_interacted
signal bought

var selling = {
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

var upgrades = {
	"damage": 0,
	"health": 0,
	"reload": 0
}

var inventory = {
	"wood": 0,
	"stone": 0
}

var days = 0
var kills = 0
var has_interacted = false

func _ready():
	Engine.set_target_fps(Engine.get_iterations_per_second())

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
