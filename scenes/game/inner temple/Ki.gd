extends Sprite

var target_pos
var speed = 30
var animator

func _ready():
	on_animation_end()

func on_animation_end():
	animator = get_node("Ki Animator")
	target_pos = Vector2(-104, 9)

func _process(delta):
	if target_pos != null && global_position != target_pos:
		var velocity = global_position.direction_to(target_pos)
		global_position += velocity * speed * delta
		animator.play("Walking")

	if target_pos != null && global_position.distance_to(target_pos) <= 1:
		global_position = target_pos
		target_pos = null
		animator.play("Default")