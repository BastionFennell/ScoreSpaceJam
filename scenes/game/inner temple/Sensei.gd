extends Area2D

var target_pos
var speed = 30
var animator
var should_move = false
var is_interactive = true

func _ready():
	self.visible = get_node("/root/Globals").get_trigger("entered_midori_dream")
	on_animation_end()

	if !self.visible:
		get_node("/root/Globals").connect("triggers_updated", self, "_on_triggers_updated")

func on_animation_end():
	animator = get_node("Sensei Animator")
	target_pos = Vector2(91, 77)

func move():
	should_move = true

func stop():
	should_move = false

func on_interact():
	get_node("../../Cutscene Manager").start_dialog("Sensei")

func _on_triggers_updated(trigger, value):
	if trigger == "entered_midori_dream":
		self.visible = value

func _process(delta):
	if target_pos != null && global_position != target_pos:
		animator.play("Walking")
		if should_move:
			var velocity = global_position.direction_to(target_pos)
			global_position += velocity * speed * delta

		if target_pos.x > global_position.x:
			get_node("Sprite").flip_h = true
		else:
			get_node("Sprite").flip_h = false

	if target_pos != null && global_position.distance_to(target_pos) <= 1:
		global_position = target_pos
		target_pos = null
		get_node("Sprite").flip_h = false
		animator.play("Default")
