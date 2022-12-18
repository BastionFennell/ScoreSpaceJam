extends Node2D

signal inventory_updated

var inventory = {
	"wood": 0,
	"stone": 0
}

var days = 0
var kills = 0

func add_item(item, amount):
	var new_amount = inventory[item] + amount if inventory[item] else amount

	inventory[item] = new_amount
	print(new_amount)
	emit_signal("inventory_updated")
