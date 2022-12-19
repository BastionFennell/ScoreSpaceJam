extends CanvasLayer

var globals

var items = { "wood": 0, "stone": 0 }

func _ready():
	globals = get_node("/root/Globals")

	globals.connect("inventory_updated", self, "_on_inventory_updated")
	_on_inventory_updated()

func _update_inventory_text():
	for i in items:
		get_node("%s GUI/Amount" % i).text = "x %s" % items[i]

func _on_inventory_updated():
	for i in items:
		items[i] = globals.inventory[i]

	_update_inventory_text()
