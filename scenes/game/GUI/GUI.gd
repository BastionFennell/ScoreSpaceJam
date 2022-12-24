extends CanvasLayer

var health_label

func _on_health_change(health):
	health_label.text = str(health)

# Called when the node enters the scene tree for the first time.
func _ready():
	health_label = get_node("Top Bar/Status/Health/Label")

func connect_to_player(player):
	player.connect("health_change", self, "_on_health_change")
	_on_health_change(player.health)
