extends Node2D

signal inventory_updated

var inventory = {
	"wood": 0,
	"stone": 0
}

var days = 0
var kills = 0

func _ready():
    Engine.set_target_fps(Engine.get_iterations_per_second())

func add_item(item, amount):
	var new_amount = inventory[item] + amount if inventory[item] else amount

	inventory[item] = new_amount
	print(new_amount)
	emit_signal("inventory_updated")
