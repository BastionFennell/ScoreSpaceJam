extends "res://scenes/game/weapons/Gun.gd"

func _init():
	reload_time = 0.5
	spread = 0
	screen_shake = 0.3
	count = 1
	damage = 5

	bullet_type = "hammer"

func setup_components():
	if parts.has("wood"):
		reload_time -= 0.1 * parts["wood"]

	if parts.has("stone"):
		damage += 3 * parts["stone"]

	if parts.has("zombie arm"):
		count += 1 * parts["zombie arm"]

static func get_upgrade_text(parts):
	var text = ""

	if parts.has("wood"):
		text += "Reloads %s seconds faster\n" % (int(parts["wood"]) * 0.1)

	if parts.has("stone"):
		text += "Deals %s more damage per bullet\n" % (int(parts["stone"]) * 3)

	if parts.has("zombie arm"):
		text += "Fires %s more bullets per shot\n" % (int(parts["zombie arm"]) * 1)

	return text

static func get_stats(parts):
	var reload_time = 2
	var count = 10
	var damage = 5

	if parts.has("wood"):
		reload_time -= 0.1 * parts["wood"]

	if parts.has("stone"):
		damage += 3 * parts["stone"]

	if parts.has("zombie arm"):
		count += 1 * parts["zombie arm"]
	
	return { "name": "Hammer", "damage": damage, "reload_time": reload_time, "count": count}
