extends CanvasLayer

var globals
var gun_man

func _ready():
	globals = get_node("/root/Globals")
	gun_man = get_node("/root/GunManager")

	get_node("Close Button").connect("pressed", self, "_on_close")
	gun_man.connect("on_set_current_guns", self, "_display_guns")

	_display_guns()

func _display_guns():
	var guns = gun_man.current_guns
	var gun_disp = get_node("Guns")
	var base = get_node("Gun Card")
	var current_gun = gun_man.current_gun

	for g in gun_disp.get_children():
		gun_disp.remove_child(g)
		g.queue_free()

	var i = 0
	for g in guns:
		var icon = gun_man.guns_data[g.type].icon

		var stats = gun_man.gun_scripts[g.type].get_stats(g.parts)

		var node = base.duplicate()
		node.gun = stats
		node.visible = true
		node.disabled = i == current_gun
		node.get_node("Sprite").texture = icon
		node.connect("pressed", self, "_on_gun_click", [i])

		gun_disp.call_deferred("add_child", node)

		i += 1

func _on_gun_click(index):
	gun_man.current_gun = index
	_display_guns()

func _on_close():
	self.visible = false
	get_tree().paused = false

func open():
	self.visible = true
	get_tree().paused = true
	_display_guns()
