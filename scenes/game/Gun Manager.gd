extends Node2D

var gun_scripts = {
    "shotgun": preload("res://scenes/game/weapons/shotgun.gd")
}
var gun_types = {
	"shotgun": preload("res://scenes/game/weapons/Shotgun.tscn")
}

var bullet_types = {
	"shotgun": preload("res://scenes/game/weapons/Shotgun Bullet.tscn"),
	"axegun": preload("res://scenes/game/weapons/Axegun Bullet.tscn")
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
	"shotgun": {
		"icon": preload("res://assets/sprites/weapons/Shotgun Icon.png"),
		"parts": 2
	}
}
var unlocked_guns = ["shotgun"]

var current_guns = [{ "type": "shotgun", "parts": { "junk": 3}}]

func get_upgrade_text(parts, type):
    print(gun_scripts[type].get_upgrade_text(parts))
    return gun_scripts[type].get_upgrade_text(parts)