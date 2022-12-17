extends CanvasLayer

func _ready():
	get_node("Resume").connect("pressed", self, "_unpause")
	get_node("Sections/Music Volume Section/Volume Slider").connect("value_changed", self, "_music_volume_changed")
	get_node("Sections/Main Volume Section/Volume Slider").connect("value_changed", self, "_main_volume_changed")

func _get_decibels(percent):
	return 20 * log(percent / 100)

func _main_volume_changed(amount):
	var decibels = _get_decibels(amount)
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), decibels)

func _music_volume_changed(amount):
	var decibels = _get_decibels(amount)
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Music"), decibels)

func _pause():
	get_tree().paused = true
	self.visible = true
	
func _unpause():
	self.visible = false
	get_tree().paused = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if Input.is_action_just_pressed("pause"):
		if(get_tree().paused):
			_unpause()
		else:
			_pause()
