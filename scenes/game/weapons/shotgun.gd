extends "res://scenes/game/weapons/Gun.gd"

func _init():
	reload_time = 2
	spread = 0.5
	screen_shake = 0.3
	count = 10
	damage = 5

	bullet_type = "shotgun"

func setup_components():
	if parts.has("wood"):
		reload_time -= 0.5 * parts["wood"]

	if parts.has("stone"):
		damage += 3 * parts["stone"]

static func get_upgrade_text(parts):
	var text = ""

	if parts.has("wood"):
		text += "Reloads %s seconds faster\n" % (int(parts["wood"]) * 0.5)

	if parts.has("stone"):
		text += "Deals %s more damage per bullet\n" % (int(parts["stone"]) * 3)

	return text
