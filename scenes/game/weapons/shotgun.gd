extends KinematicBody2D

export (int) var reload_time = 2

var Bullet = preload("res://scenes/game/weapons/Shotgun Bullet.tscn") 
var reloading = false;


func _on_shoot():
	if (!reloading):
		reloading = true
		var bullet = Bullet.instance()
		var spawner = get_node('./Bullet Spawner')

		bullet.set_rotation(spawner.global_rotation)
		bullet.set_position(spawner.global_position)

		get_node('/root/World').add_child(bullet)

		var timer = Timer.new()
		timer.one_shot = true
		timer.wait_time = reload_time
		timer.connect("timeout", self, "_reload") 
		add_child(timer)
		timer.start()

func _reload():
	reloading = false

func _process(_delta):
	look_at(get_global_mouse_position())
	if Input.is_action_pressed("shoot"):
		_on_shoot()

