extends TextureButton

var gun = {
	"reload_time": 0,
	"damage": 0,
	"count": 0
}

func _ready():
	get_node("Damage/Amount").text = "%s" % gun.damage
	get_node("Reload/Amount").text = "%ss" % gun.reload_time
	get_node("Bullets/Amount").text = "%s" % gun.count