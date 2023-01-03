extends Sprite

var target_pos
var speed = 30
var animator

func _ready():
	self.visible = get_node("/root/Globals").get_trigger("gunsmithing_unlocked")
	on_animation_end()

	if !self.visible:
		get_node("/root/Globals").connect("triggers_updated", self, "_on_triggers_updated")

func on_animation_end():
	animator = get_node("Kajiya Animator")
	target_pos = Vector2(-90, 82)

func _on_triggers_updated(trigger, value):
	if trigger == "gunsmithing_unlocked":
		self.visible = value

func _process(delta):
	if target_pos != null && global_position != target_pos:
		var velocity = global_position.direction_to(target_pos)
		global_position += velocity * speed * delta
		animator.play("Walking")

	if target_pos != null && global_position.distance_to(target_pos) <= 1:
		global_position = target_pos
		target_pos = null
		animator.play("Default")
