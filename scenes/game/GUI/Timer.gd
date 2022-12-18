extends Label

var world

func _ready():
	world = get_node("/root/World")

func _parse_time(time):
	var seconds = int(time) % 60
	var minutes = int(time / 60)
	return "%02d:%02d" % [minutes, seconds]

func _process(delta):
	self.text = _parse_time(world.time)
