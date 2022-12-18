extends KinematicBody2D

var drops = []
var weights = []

export (int) var speed = 300
export (int) var health = 5
export (int) var damage = 10

var player
var hit_box
var dead = false
signal spawn_item
signal damage_player


# Called when the node enters the scene tree for the first time.
func _ready():
	player = get_node("/root/World/Player")
	hit_box = get_node("Hit Box")

	if ($AnimationPlayer):
		$AnimationPlayer.play("walking")

	var itemSpawner = get_node("/root/World/ItemSpawner")

	self.connect("spawn_item", itemSpawner, "_on_spawn_item")
	self.connect("damage_player", player, "_on_damage")

func _explode():
	var p = get_node("Blood").duplicate()
	p.position = self.global_position

	get_node("/root/World").add_child(p)
	p.emitting = true

func damage(amount):
	health -= amount
	if health <= 0:
		dead = true
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

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(_delta):
	var velocity = Vector2.ZERO
	if (position.distance_to(player.position) > 10 && !dead):
		velocity += position.direction_to(player.position)
		move_and_slide(velocity * speed)

func _process(delta):
	if hit_box.overlaps_body(player) && !dead:
		emit_signal("damage_player", damage * delta)
