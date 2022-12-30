extends Node2D

var animator
var dialog_man

var dialog_i
var last_anim
var dialog = {
	"1 - Character Waking Up": [
		{
			"text": "Whoa... Where am I?",
			"character": "player"
		},
		{
			"text": "Is this some sort of temple? I don't recognize that statue...",
			"character": "player"
		},
		{
			"animation": "2 - Statue Zoom"
		}
	],
	"2 - Statue Zoom": [
		{
			"text": "Whatever god or goddess that is, they must have been neglected for years.",
			"character": "player"
		},
		{
			"text": "Wot 'n tarnation?",
			"character": "ki",
			"method": "ki_theme"
		},
		{
			"animation": "3 - Ki Entrance"
		}
	],
	"3 - Ki Entrance": [
		{
			"text": "We have a visitor?!",
			"character": "ki",
		},
		{
			"text": "Why, this temple hasn't had a visitor in over 20 years!",
			"character": "ki",
		},
		{
			"text": "Where'd ya come from? And how'd ya get inside without me seein ya?",
			"character": "ki",
		},
		{
			"text": "Ah! Don't scare me with a sudden music change like that!",
			"character": "player"
		},
		{
			"text": "My bad kid, let me fix that...",
			"character": "ki",
			"method": "normal_theme"
		},
		{
			"text": "Thank you, that's much more fitting.",
			"character": "player"
		},
		{
			"text": "Don't think ya can get out of answering my question with just a lil 4th wall breakin, how'd ya get here?",
			"character": "ki",
		},
		{
			"text": "Honestly? I don't know, I just kinda woke up here. Where is [b]here[/b] anyways? And who are you?",
			"character": "player"
		},
		{
			"animation": "4 - Where Is Here"
		}
	],
	"4 - Where Is Here": [
		{
			"text": "This here is the ol' temple to Yume, and I'm [b][color=#967337]Ki[/color][/b], its humble caretaker.",
			"character": "ki",
		},
		{
			"text": "If ya woke up here, I reckon Yume herself musta broughtcha here.",
			"character": "ki",
		},
		{
			"text": "What? How is that possible?",
			"character": "player"
		},
		{
			"text": "Ya see, Yume is the goddess of dreams and dreamers.",
			"character": "ki",
		},
		{
			"text": "She used to be right powerful, but now she's got less energy than me on Monday mornins...",
			"character": "ki",
		},
		{
			"text": "She musta been savin' up her energy for quite a while to summon ya here",
			"character": "ki",
		},
		{
			"text": "Which means things musta gotten real bad in the dream world.",
			"character": "ki",
		},
		{
			"animation": "5 - Bad in the Dream World"
		}
	],
	"5 - Bad in the Dream World": [{
			"text": "What do you mean things have gotten bad in the dream world?",
			"character": "player"
		},
		{
			"text": "Well, there was an old prophecy about nightmares takin over the world... I don't recall it exactly...",
			"character": "ki",
		},
		{
			"text": "Say! I reckon we could help each other out! How boutcha help me fix up the ol' prophecy chamber?",
			"character": "ki",
		},
		{
			"animation": "6 - Prophecy Chamber"
		}
	],
	"6 - Prophecy Chamber": [
		{
			"text": "How does that help me? That just sounds like manual labor...",
			"character": "player"
		},
		{
			"text": "Iffin we can find that ol' prophecy, maybe we can figure out how to getcha back home?",
			"character": "ki",
		},
		{
			"animation": "7 - Getcha Back Home"
		}
	],
	"7 - Getcha Back Home": [
		{
			"text": "Fine, I'll help... I haven't been to a temple in a long time, maybe it will put me back on the gods' good sides.",
			"character": "player"
		},
		{
			"text": "That's the spirit! Here, take this...",
			"character": "ki",
		},
		{
			"animation": "8 - Take This"
		}
	],
	"8 - Take This": [
		{
			"text": "This here is a [b]Hammer Gun[/b], you'll be needin it to getcha some materials for fixin!",
			"character": "ki",
		},
		{
			"text": "A [b]Hammer Gun[/b]? Why not just use a hammer?",
			"character": "player",
		},
		{
			"text": "The monks do things a bit different around here, you'll be gettin used to it, kid.",
			"character": "ki",
		},
		{
			"text": "First things first...",
			"character": "ki",
		},
		{
			"animation": "9 - First Things First"
		}
	],
	"9 - First Things First": [
		{
			"text": "We need some wood to fix up the ol' prophecy chamber.",
			"character": "ki",
		},
		{
			"text": "Why don'tcha use that new [b]Hammer Gun[/b] and gather some up?",
			"character": "ki",
		},
		{
			"animation": "10 - First Quest"
		}
	],
	"10 - First Quest": [
		{
			"end": true
		},
	]
}

func _ready():
	dialog_man = get_node("Dialog")
	animator = get_node("Cutscene Animator")

	dialog_man.connect("next", self, "_dialog_continue")
	animator.connect("animation_finished", self, "_animation_finished")

	animator.play("1 - Character Waking Up")
	get_tree().paused = true


func _animation_finished(anim):
	if dialog.has(anim):
		last_anim = anim
		dialog_man.visible = true
		dialog_i = -1
		_dialog_continue()

func _dialog_continue():
	var next_dialog = dialog[last_anim][dialog_i + 1]
	if next_dialog.has("end"):
		dialog_man.visible = false
		self.visible = false

		var player_pos = get_node("Cutscene Animator/Player Animator").global_position
		get_node("/root/Globals").get_player().global_position.x = player_pos.x
		get_node("/root/Globals").get_player().global_position.y = player_pos.y

		get_node("Cutscene Camera").current = false
		get_node("../Players").visible = true
		get_tree().paused = false
		get_node("/root/Globals").get_player().get_node("Camera").current = true

		queue_free()
	elif next_dialog.has("animation"):
		dialog_man.visible = false
		animator.play(next_dialog.animation)
	else:
		dialog_man.update_dialog_box(next_dialog.character, next_dialog.text)
		dialog_i += 1

	if next_dialog.has("method"):
		self.call(next_dialog.method)


func ki_theme():
	get_parent().get_node("BG Music").stream = load("res://assets/audio/Ki Theme.wav")
	get_parent().get_node("BG Music").play()

func normal_theme():
	get_parent().get_node("BG Music").stream = load("res://assets/audio/songs/Town.wav")
	get_parent().get_node("BG Music").play()
