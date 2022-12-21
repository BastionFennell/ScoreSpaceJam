extends Label

var max_time
var world

func _ready():
	world = get_node("/root/Globals").get_main_node()
	max_time = world.round_length

func _parse_time(elapsed):
	var time = max_time - elapsed
	var seconds = int(time) % 60
	var minutes = int(time / 60)
	return "%02d:%02d" % [minutes, seconds]

func _process(delta):
	self.text = _parse_time(world.time)
