extends CanvasLayer

var speaker_sprite
var text
var speaker_name

signal next

var speaker_data = {
	"ki": {
		"color": "#967337",
		"name": "Ki",
		"sprite": preload("res://scenes/game/cutscenes/Ki - Dialog.tscn")
	},
	"player": {
		"color": "#000000",
		"name": "Haiiro",
		"sprite": preload("res://scenes/game/cutscenes/Player - Dialog.tscn")
	}
}

func _ready():
	speaker_name = get_node("Speaker Name")
	speaker_sprite = get_node("Speaker")
	text = get_node("Text")

func update_dialog_box(speaker, new_text):
	speaker_name.text = speaker_data[speaker].name
	speaker_name.add_color_override("font_color", speaker_data[speaker].color)

	for i in speaker_sprite.get_children():
		speaker_sprite.remove_child(i)
		i.queue_free()

	speaker_sprite.add_child(speaker_data[speaker].sprite.instance())
	text.bbcode_text = new_text

func _process(_delta):
	if self.visible:
		if Input.is_action_just_pressed("ui_accept") || Input.is_action_just_pressed("shoot"):
			emit_signal("next")
