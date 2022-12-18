extends KinematicBody2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var player
var gun
var collected = false
var original_reload_time = 1

# Called when the node enters the scene tree for the first time.
func _ready():
	player = get_node("/root/World/Player")
	gun = player.find_node("Shotgun")
	print(" Got node " + gun.name)
	
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(_delta):
	var velocity = Vector2.ZERO
	if (position.distance_to(player.position) < 10  && !collected):
		collected = true
		_pickUp()

func _pickUp():
	original_reload_time = gun.reload_time
	gun.reload_time = original_reload_time * 0.3
	
	var timer = Timer.new()
	timer.one_shot = true
	timer.wait_time = 3
	timer.connect("timeout", gun, "_reset_reload_time")
	gun.add_child(timer)
	timer.start()
	
	queue_free()
	
