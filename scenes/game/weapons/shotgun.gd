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
		reload_time -= 0.75 * parts["wood"]

	if parts.has("stone"):
		damage += 3 * parts["stone"]