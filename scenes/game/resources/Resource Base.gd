extends RigidBody2D

var drops = []
var weights = []

export (int) var health = 5

var player
var world;
signal spawn_item


# Called when the node enters the scene tree for the first time.
func _ready():
    var globals = get_node("/root/Globals")
    world = globals.get_main_node()
    player = globals.get_player()

    if (has_node("AnimationPlayer")):
        get_node("AnimationPlayer").play("walking")

    var itemSpawner = world.get_node("ItemSpawner")

    self.connect("spawn_item", itemSpawner, "_on_spawn_item")

func _explode():
	var p = get_node("Blood").duplicate()
	p.position = self.global_position

	world.add_child(p)
	p.emitting = true

func damage(amount):
	health -= amount
	if health <= 0:
		self.visible = false
		self.remove_child(get_node("CollisionShape2D"))
		
		emit_signal("spawn_item", drops, weights, self)

		_explode()
		

		var ded = get_node("Ded")
		if ded:
			ded.playing = true
			yield(ded, "finished")

		queue_free()
	else:
		if(get_node("Oof")):
			get_node("Oof").playing = true