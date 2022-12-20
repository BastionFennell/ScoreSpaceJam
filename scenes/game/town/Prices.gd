extends NinePatchRect

export (String) var item

func _ready():
	var globals = get_node("/root/Globals")
	globals.connect("bought", self, "_on_bought")
	var item_data = globals.selling[item]

	for i in item_data.price:
		get_node(i).text = "x %s" % item_data.price[i]

func _on_bought(bought_item, item_data):
	if item == bought_item:
		for i in item_data.price:
			get_node(i).text = "x %s" % item_data.price[i]
