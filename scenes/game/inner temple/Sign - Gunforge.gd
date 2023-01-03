extends Area2D

var globals

export var price = {
	"stone": 10,
	"wood": 10
}
var is_interactive = true

func _ready():
	globals = get_node("/root/Globals")

	self.visible = !globals.get_trigger("built-gunforge")
	is_interactive = globals.get_trigger("built-signs") && !globals.get_trigger("built-gunforge")
	globals.connect("triggers_updated", self, "_on_triggers_updated")

func on_interact():
	if globals.can_afford(price):
		globals.set_trigger("built-gunforge", true)
		globals.pay(price)
		get_node("../Price Display").hide_quickly()
		globals.get_main_node().get_node("Cutscene Manager").on_build("gunforge")

func on_player_entered():
	var x = self.global_position.x - 32
	var y = self.global_position.y
	get_node("../Price Display").display(price, Vector2(x, y))

func on_player_exited():
	get_node("../Price Display").hide()

func _on_triggers_updated(updated_trigger, value):
	if updated_trigger == "built-gunforge":
		self.visible = !value
		is_interactive = globals.get_trigger("built-signs") && !value

	if updated_trigger == "built-signs":
		is_interactive = value && !globals.get_trigger("built-gunforge")
