extends CanvasLayer

var speaker_sprite
var text
var speaker_name
var current_speaker
var is_speaking
var bg_music_base_vol

signal next
signal interrupt_dialog

var speaker_data = {
	"ki": {
		"color": "#967337",
		"name": "Ki",
		"sprite": preload("res://scenes/game/cutscenes/Ki - Dialog.tscn"),
		"sounds": [
			"res://assets/audio/dialog/ki/Banjo 1.wav",
			"res://assets/audio/dialog/ki/Banjo 2.wav",
			"res://assets/audio/dialog/ki/Banjo 3.wav",
			"res://assets/audio/dialog/ki/Banjo 4.wav",
		]
	},
	"player": {
		"color": "#000000",
		"name": "Haiiro",
		"sprite": preload("res://scenes/game/cutscenes/Player - Dialog.tscn"),
		"sounds": [
			"res://assets/audio/dialog/haiiro/Shamisen 1.wav",
			"res://assets/audio/dialog/haiiro/Shamisen 2.wav",
			"res://assets/audio/dialog/haiiro/Shamisen 3.wav",
			"res://assets/audio/dialog/haiiro/Shamisen 4.wav",
		]
	},
	"yume": {
		"color": "#1b5c84",
		"name": "Yume",
		"sprite": preload("res://scenes/game/cutscenes/Yume - Dialog.tscn"),
		"sounds": [
			"res://assets/audio/dialog/yume/Pan Flute 1.wav",
			"res://assets/audio/dialog/yume/Pan Flute 2.wav",
			"res://assets/audio/dialog/yume/Pan Flute 3.wav",
			"res://assets/audio/dialog/yume/Pan Flute 4.wav",
		]
	},
}

func _ready():
	speaker_name = get_node("Speaker Name")
	speaker_sprite = get_node("Speaker")
	text = get_node("Text")

	bg_music_base_vol = get_node("../../BG Music").volume_db

	get_node("Text").connect("dialog_complete", self, "_on_dialog_complete")
	self.connect("interrupt_dialog", get_node("Text"), "_on_interrupt_dialog")

func update_dialog_box(speaker, new_text):
	get_node("../../BG Music").volume_db = bg_music_base_vol - 6

	current_speaker = speaker
	speaker_name.text = speaker_data[speaker].name
	speaker_name.add_color_override("font_color", speaker_data[speaker].color)

	for i in speaker_sprite.get_children():
		speaker_sprite.remove_child(i)
		i.queue_free()

	speaker_sprite.add_child(speaker_data[speaker].sprite.instance())
	text.new_message = new_text
	is_speaking = true

func _on_dialog_complete():
	get_node("../../BG Music").volume_db = bg_music_base_vol
	is_speaking = false

func _process(_delta):
	if self.visible:
		if Input.is_action_just_pressed("ui_accept") || Input.is_action_just_pressed("shoot"):
			if is_speaking:
				emit_signal("interrupt_dialog")
			else:
				emit_signal("next")