extends Sprite

var hit_box
var globals

func _ready():
	globals = get_node("/root/Globals")
	hit_box = get_node("Area2D")

func _process(_delta):
	for b in hit_box.get_overlapping_bodies():
		if !globals.networked:
			if b.name == "0":
				globals.transition_to("nightmare")
		elif b.name == "1" && b.is_network_master():
			globals.transition_to("nightmare")