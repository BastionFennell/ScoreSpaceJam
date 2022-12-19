extends CanvasLayer

var score_submitted = false
var globals

func _ready():
	var button = get_node("./Retry")
	var add_highscore = get_node("Submit Score")
	var player = get_node("/root/World/Player")
	globals = get_node("/root/Globals")

	button.connect("pressed", self, "_retry")
	add_highscore.connect("pressed", self, "_on_submit")
	player.connect("player_death", self, "_on_death")

func _parse_time(time, days):
	var seconds = int(time) % 60
	var minutes = int(time / 60)
	if days == 1:
		return "%d day, %d minutes, and %d seconds" % [days, minutes, seconds]
	else:
		return "%d days, %d minutes, and %d seconds" % [days, minutes, seconds]

func _set_high_scores(high_scores):
	for i in high_scores.size():
		var hdays = 0 if !high_scores[i].has("days") else high_scores[i].days
		var string = "High Scores/%d" % i
		var node = get_node("High Scores/%d" % (i + 1))
		node.get_node("Name").text = high_scores[i].name
		node.get_node("Score").text = _parse_time(int(high_scores[i].score), hdays)

func _on_submit():
	var world = get_node("/root/World")
	var days = globals.days
	var time = _parse_time(world.time, days)
	if score_submitted:
		return

	score_submitted = true


	var save_game = File.new()
	if save_game.file_exists("user://savegame.save"):
		save_game.open("user://savegame.save", File.READ)
		var data = parse_json(save_game.get_as_text())
		var high_scores = []
		var submitIndex = 5

		if data.has("high_scores"):
			high_scores = data.high_scores
			for i in high_scores.size():
				var hdays = 0 if !high_scores[i].has("days") else high_scores[i].days
				if days > hdays && submitIndex == 5:
						submitIndex = i
				elif days == hdays && int(world.time) > int(high_scores[i].score) && submitIndex == 5:
						submitIndex = i
			
			if submitIndex == 5 && high_scores.size() < 5:
				submitIndex = high_scores.size()
		
			if submitIndex < 5:
				var first_highscores = [] if submitIndex == 0 else high_scores.slice(0, submitIndex - 1)
				var last_highscores = high_scores.slice(submitIndex, 5)
				high_scores = first_highscores + [{ "name": get_node("Name").text, "score": time, "days": days}] + last_highscores
				high_scores = high_scores.slice(0, 4)

				_set_high_scores(high_scores)
				data.high_scores = high_scores

				save_game.open("user://savegame.save", File.WRITE)
				save_game.store_string(to_json(data))
		
		save_game.close()

func _on_death():
	var world = get_node("/root/World")
	var days = globals.days
	world.stop_time()
	var time = _parse_time(world.time, days)
	get_node("Survived").text = "You survived for: " + time

	var save_game = File.new()

	var data = {}
	if save_game.file_exists("user://savegame.save"):
		save_game.open("user://savegame.save", File.READ)
		data = parse_json(save_game.get_as_text())
	
	if data.has("high_scores"):
		_set_high_scores(data.high_scores)

	save_game.close()
	self.visible = true
	get_tree().paused = true

func _retry():
	get_node("/root/Globals").reset()
	get_tree().paused = false
	get_tree().change_scene("res://Twilight.tscn")
