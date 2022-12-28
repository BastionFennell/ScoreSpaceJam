extends RigidBody2D

puppet var puppet_position = Vector2(0, 0) setget puppet_position_set
puppet var puppet_velocity = Vector2(0, 0) setget puppet_velocity_set

var drops = []
var weights = []
var velocity

export (int) var speed = 300
export (int) var health = 5
export (int) var damage = 10

export (int) var speed_inc = 5
export (int) var health_inc = 0
export (int) var damage_inc = 5

var tween
var player
var world
var globals
var hit_box
var dead = false
var is_server = false
signal spawn_item
signal damage_player


# Called when the node enters the scene tree for the first time.
func _ready():
	is_server = get_tree().is_network_server()

	globals = get_node("/root/Globals")
	world = globals.get_main_node()
	player = globals.get_player()
	hit_box = get_node("Hit Box")
	tween = get_node("Tween")

	if (has_node("AnimationPlayer")):
		get_node("AnimationPlayer").play("walking")

	var itemSpawner = world.get_node("ItemSpawner")

	self.connect("spawn_item", itemSpawner, "_on_spawn_item")
	self.connect("damage_player", player, "_on_damage")

	var days = get_node("/root/Globals").days
	speed = speed + speed_inc * days
	health = health + health_inc * days
	damage = damage + damage_inc * days

func puppet_position_set(pos):
	# We could be smarter about the sanity check here. Ideally we'd have a timer and if someone is
	# sending updated positions but is out of bounds for x seconds we just update their position
	if puppet_position != pos && puppet_position.distance_to(pos) < 500:
		puppet_position = pos
		tween.interpolate_property(self, "global_position", global_position, puppet_position, 0.1)
		tween.start()

func puppet_velocity_set(vel):
	# We could be smarter about the sanity check here. Ideally we'd have a timer and if someone is
	# sending updated positions but is out of bounds for x seconds we just update their position
	if abs(vel.x) < 500 && abs(vel.y) < 500:
		puppet_velocity = vel

func _explode():
	var p = get_node("Blood").duplicate()
	p.position = self.global_position

	world.add_child(p)
	p.emitting = true

func damage(amount):
	if globals.networked:
		rpc("deal_damage", amount)
	else:
		deal_damage(amount)

remotesync func deal_damage(amount):
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

func get_closest_player(players):
	var closest_player = 0
	var distance_to = 1000000000000
	for p in players:
		var curr_distance = self.global_position.distance_to(p.global_position)
		if curr_distance < distance_to:
			closest_player = p
			distance_to = curr_distance

	return closest_player

func _integrate_forces(_delta):
	if !globals.networked || is_server:
		var closest_player = get_closest_player(world.get_node("Players").get_children())
		velocity = Vector2.ZERO
		if (global_position.distance_to(closest_player.global_position) > 10 && !dead):
			velocity += position.direction_to(closest_player.global_position)
			self.linear_velocity = velocity * speed 
		else:
			self.linear_velocity = Vector2.ZERO

		if(velocity.x < 0):
			$Sprite.flip_h = false
		elif(velocity.x > 0):
			$Sprite.flip_h = true

	else:
		if !tween.is_active():
			linear_velocity = puppet_velocity * speed

		if(puppet_velocity.x < 0):
			$Sprite.flip_h = true
		elif(puppet_velocity.x > 0):
			$Sprite.flip_h = false

func _process(delta):
	if hit_box.overlaps_body(player) && !dead:
		emit_signal("damage_player", damage * delta)
