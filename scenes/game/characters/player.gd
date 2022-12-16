extends KinematicBody2D

export (int) var speed = 1000;

var velocity = Vector2()

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


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	get_input()
	velocity = move_and_slide(velocity)
