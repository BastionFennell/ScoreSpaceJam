extends "../Resource Base.gd"

var Wood = preload("res://scenes/game/drops/Wood/Wood.tscn")

func _ready():
	if get_node("/root/Globals").get_trigger("holy_tree_destroyed"):
		self.visible =false
		self.queue_free()

	health = 5
	drops = [Wood]
	weights = [100]

func damage(amount):
	self.remove_child(get_node("CollisionShape2D"))

	_explode()

	var ded = get_node("Ded")
	if ded:
		ded.playing = true
		yield(ded, "finished")

	get_node("/root/Globals").set_trigger("holy_tree_destroyed", true)

	get_node("../../Cutscene Manager").tree_killed()

	self.queue_free()
