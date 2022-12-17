extends NinePatchRect

export (String) var audio_bus;

func _ready():
	get_node("Volume Slider").connect("value_changed", self, "_volume_changed")

func _get_decibels(percent):
	return 20 * log(percent / 100)

func _volume_changed(amount):
	var decibels = _get_decibels(amount)
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index(audio_bus), decibels)