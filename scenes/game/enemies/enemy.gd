extends KinematicBody2D

var drops = []
var weights = []

export (int) var speed = 300
export (int) var health = 5
export (int) var damage = 10

export (int) var speed_inc = 5
export (int) var health_inc = 0
export (int) var damage_inc = 5

var player
var world;
var hit_box
var dead = false
signal spawn_item
signal damage_player


# Called when the node enters the scene tree for the first time.
func _ready():
	world = get_node("/root/Globals").get_main_node()
	player = world.get_node("Player")
	hit_box = get_node("Hit Box")

	if (has_node("AnimationPlayer")):
		get_node("AnimationPlayer").play("walking")

	var itemSpawner = world.get_node("ItemSpawner")

	self.connect("spawn_item", itemSpawner, "_on_spawn_item")
	self.connect("damage_player", player, "_on_damage")

	var days = get_node("/root/Globals").days
	speed = speed + speed_inc * days
	health = health + health_inc * days
	damage = damage + damage_inc * days

func _explode():
	var p = get_node("Blood").duplicate()
	p.position = self.global_position

	world.add_child(p)
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
