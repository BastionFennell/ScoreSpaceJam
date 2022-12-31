extends Node2D

var animator
var dialog_man
var globals

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
			"method": "ki_entrance"
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
			"text": "I'll be waitin for ya over on by the ol' prophecy chamber when yer ready.",
			"character": "ki",
		},
		{
			"end": true,
			"method": "intro_end"
		},
	],
	"11 - Tree Killed": [
		{
			"text": "[b]OH MY GOSH, DID YOU JUST SHOOT DOWN THE HOLY TREE!?!?[/b]",
			"character": "ki",
			"method": "ki_theme"
		},
		{
			"text": "[b]THAT THERE TREE WAS O'ER A THOUSAND YEARS OLD![/b]",
			"character": "ki",
		},
		{
			"text": "I thought you said you needed some wood?",
			"character": "player",
		},
		{
			"text": "[b]FROM OUTSIDE! WHAT KIND OF MANIAC SHOOTS DOWN A SACRED TREE?!?[/b]",
			"character": "ki",
		},
		{
			"text": "Maybe using it to fix the prophecy room will make the room extra holy?",
			"character": "player",
		},
		{
			"text": "Gosh darn it... I can't let that wood go to waste. Gimme a moment here and the room will be good as new...",
			"character": "ki",
			"method": "normal_theme"
		},
		{
			"end": true
		},
	]
}

func _ready():
	dialog_man = get_node("Dialog")
	animator = get_node("Cutscene Animator")
	globals = get_node("/root/Globals")

	dialog_man.connect("next", self, "_dialog_continue")
	animator.connect("animation_finished", self, "_animation_finished")

	if !globals.cutscenes.intro:
		get_node("Cutscene Camera").current = true
		get_node("../Players").visible = false
		get_node("../NPCs").visible = false
		self.visible = true

		animator.play("1 - Character Waking Up")
		get_tree().paused = true

func tree_killed():
		var curr_cam = globals.get_player().get_node("Camera")
		print(curr_cam.global_position)
		get_node("Cutscene Camera").global_position = curr_cam.global_position
		get_node("Cutscene Camera").zoom = curr_cam.zoom
		get_node("Cutscene Camera").current = true
		get_node("../Players").visible = false
		get_node("../NPCs").visible = false
		self.visible = true

		animator.play("11 - Tree Killed")
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
		normal_theme()
		dialog_man.visible = false
		self.visible = false
		
		get_node("../NPCs").visible = true

		get_node("Cutscene Camera").current = false
		get_node("../Players").visible = true
		get_tree().paused = false
		globals.get_player().get_node("Camera").current = true
		self.visible = false

		globals.cutscenes.intro = true
	elif next_dialog.has("animation"):
		dialog_man.visible = false
		animator.play(next_dialog.animation)
	else:
		dialog_man.update_dialog_box(next_dialog.character, next_dialog.text)
		dialog_i += 1

	if next_dialog.has("method"):
		self.call(next_dialog.method)

func intro_end():
	var player_pos = get_node("Sprites/Player Animator").global_position
	globals.get_player().global_position.x = player_pos.x
	globals.get_player().global_position.y = player_pos.y

	var ki = get_node("../NPCs/Ki")
	var ki_pos = get_node("Sprites/Ki Animator").global_position
	ki.global_position.x = ki_pos.x
	ki.global_position.y = ki_pos.y
	ki.on_intro_animation_end()

func ki_entrance():
	play_door()
	ki_theme()

func ki_theme():
	get_parent().get_node("BG Music").stream = load("res://assets/audio/Ki Theme.wav")
	get_parent().get_node("BG Music").play()

func normal_theme():
	get_parent().get_node("BG Music").stream = load("res://assets/audio/songs/Town.wav")
	get_parent().get_node("BG Music").play()

func _play_sfx(sfx):
	var SFX = get_node("SFX")
	SFX.stream = load("res://assets/audio/%s" % sfx)
	SFX.pitch_scale = rand_range(0.8, 1.2)
	SFX.play()

func play_footstep():
	_play_sfx("footstep 1.wav")

func play_jump():
	_play_sfx("jump.wav")

func play_pickup():
	_play_sfx("item pickup.wav")

func play_door():
	_play_sfx("door.wav")
