extends KinematicBody2D

export (int) var speed = 1000
export (float) var health = 100.00

signal health_change
var velocity = Vector2()
var touching = 0;

func get_input():
	velocity = Vector2()

	if Input.is_action_pressed("ui_right"):
		velocity.x += Input.get_action_strength("ui_right")
	if Input.is_action_pressed("ui_left"):
		velocity.x -= Input.get_action_strength("ui_left")
	if Input.is_action_pressed("ui_up"):
		velocity.y -= Input.get_action_strength("ui_up")
	if Input.is_action_pressed("ui_down"):
		velocity.y += Input.get_action_strength("ui_down")

	velocity = velocity.normalized() * speed


func _on_damage(damage):
	health -= damage
	emit_signal("health_change", health);

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	get_input()
	velocity = move_and_slide(velocity)
