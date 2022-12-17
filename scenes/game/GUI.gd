extends MarginContainer

var health_label

func _on_health_change(health):
	health_label.text = str(health)

# Called when the node enters the scene tree for the first time.
func _ready():
	var player = get_node("/root/World/Player")
	player.connect("health_change", self, "_on_health_change")

	health_label = get_node("Top Bar/Status/Health/Label")
	_on_health_change(player.health)
