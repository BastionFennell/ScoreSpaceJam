extends CanvasLayer

func _ready():
	get_node("Grid/Resume").connect("pressed", self, "_unpause")

func _pause():
	get_tree().paused = true
	self.visible = true

	get_node("Grid/Volume Sliders/Main Volume Section/Volume Slider").grab_focus()
	
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