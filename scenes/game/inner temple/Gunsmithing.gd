extends CanvasLayer

var globals
var gun_man
var selected_schematic
var selected_parts = {}

func _ready():
	globals = get_node("/root/Globals")
	gun_man = get_node("/root/GunManager")

	get_node("Make Button").connect("pressed", self, "_on_make")
	get_node("Close Button").connect("pressed", self, "_on_close")

	_display_inventory()
	_display_schematics()

func _display_inventory():
	var inventory = globals.inventory
	var icons = globals.inventory_icons
	var inv_disp = get_node("Inventory Scroll/Inventory")
	var base = get_node("Item Base")

	for i in inv_disp.get_children():
		inv_disp.remove_child(i)
		i.queue_free()

	for i in inventory:
		var node = base.duplicate()
		node.visible = true
		node.get_node("Sprite").texture = icons[i]
		node.get_node("Amount").text = str(inventory[i])
		node.item = i

		inv_disp.call_deferred("add_child", node)

func _display_schematics():
	var guns = gun_man.unlocked_guns
	var guns_disp = get_node("Schematics Scroll/Schematics")
	var base = get_node("Schematic Base")

	for i in guns:
		var node = base.duplicate()
		node.visible = true
		node.get_node("Sprite").texture = gun_man.guns_data[i].icon
		node.get_node("Label").text = i
		node.connect("pressed", self, "_on_schematic_click", [i])

		guns_disp.add_child(node)

func _on_part_selected(part, i):
	selected_parts[i] = part

	_check_parts()

func _display_selected_schematic():
	var parts = gun_man.guns_data[selected_schematic].parts
	var components_disp = get_node("Components")
	var base = get_node("Component Base")

	for i in components_disp.get_children():
		components_disp.remove_child(i)
		i.queue_free()

	for i in parts:
		var node = base.duplicate()
		node.visible = true
		node.connect("part_selected", self, "_on_part_selected", [i])

		components_disp.add_child(node)

	components_disp.visible = true

func _on_schematic_click(schematic):
	selected_schematic = schematic
	selected_parts = {}
	_display_selected_schematic()

func _check_parts():
	var parts = gun_man.guns_data[selected_schematic].parts

	for i in parts:
		if !selected_parts.has(i) || !selected_parts[i]:
			get_node("Upgrade Info").visible = false
			get_node("Make Button").visible = false
			return false

	var gun_type = gun_man.gun_types[selected_schematic]

	var part_amounts = {}
	for i in selected_parts:
		var part = selected_parts[i]
		if part_amounts.has(part):
			part_amounts[part] += 1
		else:
			part_amounts[part] = 1

	get_node("Upgrade Info").text = gun_man.get_upgrade_text(part_amounts, selected_schematic)
	get_node("Upgrade Info").visible = true
	get_node("Make Button").visible = true

func _on_make():
	var new_gun = {
		"type": selected_schematic,
		"parts": {}
	}

	for i in selected_parts:
		var part = selected_parts[i]
		globals.inventory[part] -= 1
		if new_gun.parts.has(part):
			new_gun.parts[part] += 1
		else:
			new_gun.parts[part] = 1

	_display_selected_schematic()
	_display_inventory()
	gun_man.add_gun(new_gun)
	globals.get_player().update_gun()
	
	selected_schematic = null
	selected_parts = {}
	get_node("Upgrade Info").visible = false
	get_node("Make Button").visible = false

	var components_disp = get_node("Components")

	for i in components_disp.get_children():
		components_disp.remove_child(i)
		i.queue_free()

func _on_close():
	self.visible = false
	get_tree().paused = false

func open():
	self.visible = true
	get_tree().paused = true
