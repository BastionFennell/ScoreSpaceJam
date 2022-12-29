extends "../Drop Base.gd"
var gun

# Called when the node enters the scene tree for the first time.
func _ready():
	gun = player.get_gun()
	
func _pickUp():
	#gun._temp_speed_buff()
