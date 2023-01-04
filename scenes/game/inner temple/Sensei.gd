extends Sprite

var target_pos
var speed = 30
var animator
var should_move = false

func _ready():
	on_animation_end()

func on_animation_end():
	animator = get_node("Sensei Animator")
	target_pos = Vector2(91, 77)

func move():
	should_move = true

func stop():
	should_move = false

func _process(delta):
	if target_pos != null && global_position != target_pos:
		animator.play("Walking")
		if should_move:
			var velocity = global_position.direction_to(target_pos)
			global_position += velocity * speed * delta

		if target_pos.x > global_position.x:
			self.flip_h = true
		else:
			self.flip_h = false

	if target_pos != null && global_position.distance_to(target_pos) <= 1:
		global_position = target_pos
		target_pos = null
		self.flip_h = false
		animator.play("Default")
