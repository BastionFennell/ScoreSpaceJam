extends Node2D

var globals
var box
var fader
var price_list

func _ready():
	globals = get_node("/root/Globals")
	box = get_node("Display Box")
	fader = get_node("Fader")
	price_list = box.get_node("Price List")

func display(price, position):
	box.global_position = position
	_display_price(price)
	fader.play("Fade In")

func _display_price(price):
	var icons = globals.inventory_icons
	var base = get_node("Item Display Base")
	
	for c in price_list.get_children():
		price_list.remove_child(c)
		c.queue_free()

	for p in price:
		var line = base.duplicate()
		line.visible = true
		line.get_node("Item").texture = icons[p]
		line.get_node("Price").text = "x%s" % price[p]

		price_list.add_child(line)

func hide():
	fader.play("Fade Out")

func hide_quickly():
	fader.stop()
	self.modulate = "#00ffffff"
