extends Node2D

signal on_set_current_guns
signal change_current_gun

var gun_scripts = {
	"hammergun": preload("res://scenes/game/weapons/hammergun.gd"),
	"shotgun": preload("res://scenes/game/weapons/shotgun.gd"),
	"rifle": preload("res://scenes/game/weapons/rifle.gd")
}
var gun_types = {
	"hammergun": preload("res://scenes/game/weapons/Hammergun.tscn"),
	"shotgun": preload("res://scenes/game/weapons/Shotgun.tscn"),
	"rifle": preload("res://scenes/game/weapons/Rifle.tscn")
}

var bullet_types = {
	"shotgun": preload("res://scenes/game/weapons/Shotgun Bullet.tscn"),
	"hammer": preload("res://scenes/game/weapons/Hammergun Bullet.tscn")
}

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
	"hammergun": {
		"icon": preload("res://assets/sprites/weapons/HammerGun Icon.png"),
		"parts": 2
	},
	"shotgun": {
		"icon": preload("res://assets/sprites/weapons/Shotgun Icon.png"),
		"parts": 2
	},
	"rifle": {
		"icon": preload("res://assets/sprites/weapons/Rifle Icon.png"),
		"parts": 2
	}
}
var unlocked_guns = {
	"hammergun": false,
    "rifle": false,
    "shotgun": true 
}

var current_guns = [
	{
		"type": "hammergun",
		"parts": { "junk": 2}
	},
	{
		"type": "shotgun",
		"parts": { "junk": 2}
	}]
var current_gun = 0 setget set_current_gun

func get_upgrade_text(parts, type):
	print(gun_scripts[type].get_upgrade_text(parts))
	return gun_scripts[type].get_upgrade_text(parts)

func add_gun(new_gun):
	current_guns.append(new_gun)
	emit_signal("on_set_current_guns")

	current_gun = current_guns.size() - 1

func set_current_gun(new_gun):
	current_gun = new_gun

	emit_signal("change_current_gun")
