extends "../Resource Base.gd"

var Stone = preload("res://scenes/game/drops/Stone/Stone.tscn")

func _ready():
	health = 10
	drops = [Stone]
	weights = [100]
