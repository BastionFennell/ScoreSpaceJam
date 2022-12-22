extends CanvasLayer

var globals
var selected_gun
var selected_parts = {}

func _ready():
	globals =get_node("/root/Globals")
	_populate_parts()
	_populate_guns()

func _populate_guns():
	var unlocked_guns = globals.unlocked_guns
	var gun_row = get_node("Guns Base")
	var guns_column = get_node("Guns List")

	for gun_name in unlocked_guns:
		print(gun_name)
		var new_row = gun_row.duplicate()
		new_row.get_node("Name").text = gun_name
		new_row.visible = true
		
		var button = new_row.get_node("Make")
		button.connect("pressed", self, "_on_choose_gun", [gun_name])

		guns_column.add_child(new_row)

func _on_choose_gun(gun_name):
	selected_gun = gun_name
	var gun = globals.guns_data[gun_name]
	var part_row = get_node("Parts Base")
	var parts_column = get_node("Gun Parts List")

	for n in parts_column.get_children():
		parts_column.remove_child(n)
		n.queue_free()

	for part in gun.parts:
		var new_row = part_row.duplicate()
		new_row.get_node("Name").text = part
		new_row.visible = true
		
		var button = new_row.get_node("Make")
		button.connect("pressed", self, "_on_choose_gun_part", [gun_name, part])

		parts_column.add_child(new_row)

func _on_choose_gun_part(gun_name, part):
	var material_row = get_node("Materials Base")
	var materials_column = get_node("Materials List")

	for n in materials_column.get_children():
		materials_column.remove_child(n)
		n.queue_free()

	if !globals.parts_inventory.has(part):
		return

	var materials = globals.parts_inventory[part]
	for material in materials:
		var amount = materials[material]
		var new_row = material_row.duplicate()
		new_row.get_node("Name").text = material
		new_row.get_node("Price").text = str(amount)
		new_row.visible = true
		
		var button = new_row.get_node("Make")
		button.connect("pressed", self, "_on_select_gun_part_material", [gun_name, part, material])

		materials_column.add_child(new_row)

func _on_select_gun_part_material(gun_name, part, material):
	selected_parts[part] = material

func _populate_parts():
	var parts_data = globals.parts_data
	var unlocked_parts = globals.unlocked_parts
	var part_row = get_node("Parts Base")
	var parts_column = get_node("Parts List")

	for part_name in unlocked_parts:
		var part = parts_data[part_name]
		var new_row = part_row.duplicate()
		new_row.get_node("Name").text = part_name
		new_row.get_node("Price").text = str(part.price)
		new_row.visible = true
		
		var button = new_row.get_node("Make")
		button.connect("pressed", self, "_on_choose_part", [part_name])

		parts_column.add_child(new_row)
	
func _on_choose_part(part_name):
	_populate_materials(part_name)

func _populate_materials(part_name):
	var material_row = get_node("Materials Base")
	var materials_column = get_node("Materials List")

	for n in materials_column.get_children():
		materials_column.remove_child(n)
		n.queue_free()

	var materials = globals.inventory
	for material in materials:
		var amount = materials[material]
		var new_row = material_row.duplicate()
		new_row.get_node("Name").text = material
		new_row.get_node("Price").text = str(amount)
		new_row.visible = true
		
		var button = new_row.get_node("Make")
		button.connect("pressed", self, "_on_make", [part_name, material])

		materials_column.add_child(new_row)

func _on_make(part_name, material):
	var part = globals.parts_data[part_name]
	var inventory = globals.inventory
	globals.inventory[material] -= part.price

	if !globals.parts_inventory.has(part_name):
		globals.parts_inventory[part_name] = {}

	if !globals.parts_inventory[part_name].has(material):
		globals.parts_inventory[part_name][material] =0

	globals.parts_inventory[part_name][material] += 1

func _process(delta):
	if selected_gun:
		var gun_data = globals.guns_data[selected_gun]
		if selected_parts.size() == gun_data.parts.size():
			get_node("Smith Button").visible = true
		else:
			get_node("Smith Button").visible = false
