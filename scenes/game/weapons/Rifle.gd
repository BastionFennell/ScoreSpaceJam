extends "res://scenes/game/weapons/Gun.gd"

func _init():
	max_ammo = 10
	reload_time = 0.2
	fire_delay = 0.03
	spread = 0.1
	screen_shake = 0.1
	count = 1
	damage = 1
	speed = 200
	lifetime = 1.2

	bullet_type = "shotgun"

func setup_components():
	if parts.has("wood"):
		reload_time -= 0.01 * parts["wood"]

	if parts.has("stone"):
		damage += 1 * parts["stone"]

static func get_upgrade_text(parts):
	var text = ""

	if parts.has("wood"):
		text += "Reloads %s seconds faster\n" % (int(parts["wood"]) * 0.01)

	if parts.has("stone"):
		text += "Deals %s more damage per bullet\n" % (int(parts["stone"]) * 1)

	return text

static func get_stats(parts):
	var reload_time = 0.1
	var count = 1
	var damage = 1

	if parts.has("wood"):
		reload_time -= 0.01 * parts["wood"]

	if parts.has("stone"):
		damage += 1 * parts["stone"]
	
	return { "name": "Rifle", "damage": damage, "reload_time": reload_time, "count": count}
