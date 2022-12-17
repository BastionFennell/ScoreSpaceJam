extends NinePatchRect

export (String) var audio_bus;

func _ready():
	get_node("Volume Slider").connect("value_changed", self, "_volume_changed")

	var save_game = File.new()
	if save_game.file_exists("user://savegame.save"):
		save_game.open("user://savegame.save", File.READ)
		var data = parse_json(save_game.get_as_text())
		if data.has("volume") && data.volume.has(audio_bus):
			var initial_amount = data.volume[audio_bus]
			_volume_changed(initial_amount)
			get_node("Volume Slider").value = initial_amount


func _get_decibels(percent):
	return 20 * log(percent / 100)

func _save_volume(amount):
	var save_game = File.new()
	var data = {}
	if save_game.file_exists("user://savegame.save"):
		save_game.open("user://savegame.save", File.READ)
		data = parse_json(save_game.get_as_text())
	
	if !data.has("volume"):
		data.volume = {}

	data.volume[audio_bus] = amount
	
	save_game.open("user://savegame.save", File.WRITE)
	save_game.store_string(to_json(data))
	save_game.close()



func _volume_changed(amount):
	var decibels = _get_decibels(amount)
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index(audio_bus), decibels)

	_save_volume(amount)
