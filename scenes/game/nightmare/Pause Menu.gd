extends CanvasLayer

var globals

func _ready():
	globals = get_node("/root/Globals")
	get_node("Grid/Resume").connect("pressed", self, "_unpause")
	get_node("Grid/Start Server").connect("pressed", self, "_start_server")
	get_node("Grid/Join Server").connect("pressed", self, "_join_server")

func _pause():
	if !get_tree().paused:
		get_tree().paused = true
		self.visible = true

		get_node("Grid/Volume Sliders/Main Volume Section/Volume Slider").grab_focus()
	
func _unpause():
	self.visible = false
	get_tree().paused = false

func _start_server():
	globals.start_server()

func _join_server():
	var ip = get_node("Grid/Join Server/IP Address").text
	print(ip)
	globals.connect_to_server(ip)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if Input.is_action_just_pressed("pause"):
		if(get_tree().paused):
			_unpause()
		else:
			_pause()
