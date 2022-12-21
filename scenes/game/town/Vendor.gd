extends Area2D

export (String) var selling

var player
var globals

func _ready():
	globals = get_node("/root/Globals")
	player = globals.get_player()
	var how_to = player.get_node("How to Interact")

	self.connect("body_exited", how_to, "area_exited")
	self.connect("body_entered", how_to, "area_entered")

func _buy():
	var price = globals.selling[selling].price
	var upgrade = globals.selling[selling].upgrade
	var inventory = globals.inventory

	var can_afford = true
	for i in price:
		if inventory[i] < price[i]:
			can_afford = false
	
	if can_afford:
		for i in price:
			inventory[i] -= price[i]
		
		globals.upgrades[upgrade] += 1
		globals.on_buy(selling)


func _process(delta):
	if overlaps_body(player) && Input.is_action_just_pressed("ui_accept"):
		if !globals.has_interacted:
			globals.on_first_interact()
		_buy()
