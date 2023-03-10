extends Node2D

var bg_music_base_vol
var animator
var dialog_man
var globals
var player
var is_in_cutscene = false

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
			"text": "Just use [b]left mouse click[/b] or [b]RT[/b] to shoot!",
			"character": "ki",
		},
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
			"text": "Gosh darn it... I can't let that wood go to waste. Just gimme a sec to mourn...",
			"character": "ki",
			"method": "normal_theme"
		},
		{
			"text": "...",
			"character": "ki",
		},
		{
			"text": "...",
			"character": "ki",
		},
		{
			"text": "...",
			"character": "ki",
		},
		{
			"text": "Alright, lets see if that there wood is any good for construction, I suppose...",
			"character": "ki",
		},
		{
			"animation": "12 - Fix Prophecy Chamber",
			"method": "set_tree_killed"
		},
	],
	"11 - Got Wood": [
		{
			"text": "Well I'll be, ya already found some wood!",
			"character": "ki",
		},
		{
			"text": "Gimme a piece of that and I'll get this prophecy chamber fixed up in a jiffy!",
			"character": "ki",
		},
		{
			"animation": "12 - Fix Prophecy Chamber"
		}
	],
	"12 - Fix Prophecy Chamber": [
		{
			"text": "There we go, good as new!",
			"character": "ki",
			"method": "prophecy_chamber_rebuilt"
		},
		{
			"text": "Why dontcha go check on the prophecy then?",
			"character": "ki",
		},
		{
			"text": "Just get close to it and hit [b]E[/b] or [b]A/X[/b] if you're on controller.",
			"character": "ki",
		},
		{
			"end": true,
		}
	],
	"13 - Read Prophecy": [
		{
			"text": "Great, so I'm supposed to sleep in these monks' rooms and somehow rescue them from a nightmare?",
			"character": "player",
		},
		{
			"text": "I made them beds m'self, they're right comfortable, trust me!",
			"character": "ki",
		},
		{
			"text": "How comfortable they are isn't the issue here...",
			"character": "player",
		},
		{
			"text": "What's yer problem then?",
			"character": "ki",
		},
		{
			"text": "It's just weird, okay?",
			"character": "player",
		},
		{
			"text": "Well, you don't havta do it. Just means you'll probably never get home, what a darn shame...",
			"character": "ki",
		},
		{
			"text": "Fine, I get it... I'll give it a shot.",
			"character": "player",
		},
		{
			"text": "Great!",
			"character": "ki",
		},
		{
			"animation": "14 - Midori Bed Zoom"
		}
	],
	"14 - Midori Bed Zoom": [ 
		{
			"text": "Midori's bed here is the only one I've got fixed up so far. Why dontcha start with him?",
			"character": "ki",
		},
		{
			"text": "Seems as good a place to start as any...",
			"character": "player",
		},
		{
			"text": "Great! Just walk up to that there bed and [b]interact[/b] with it, lets see what happens!",
			"character": "ki",
		},
		{
			"end": true,
			"method": "unlock_midori_bed"
		}
	],
	"15 - On First Dive": [ 
		{
			"text": "Oh, right, I reckon you should probably pray to Yume before your first dreamwalk. Just in case, y'know?",
			"character": "ki",
		},
		{
			"end": true,
		}
	],
	"16 - Meet Yume": [ 
		{
			"text": "Well... I've never really prayed like this before, so I'm not quite sure what to do.",
			"character": "player",
		},
		{
			"text": "Yume, if you're still alive... And listening, I guess... I could really use some help and guidance...",
			"character": "player",
		},
		{
			"text": "Worry not, my child. I am listening. I am too weak right now to offer you much.",
			"character": "yume",
		},
		{
			"text": "Wait, you're real!?",
			"character": "player",
		},
		{
			"text": "Of course I am. Who did you think brought you here in the first place?",
			"character": "yume",
		},
		{
			"text": "Honestly, I'm still kind of assuming this is all a dream... If it's not, how can I make you stronger?",
			"character": "player",
		},
		{
			"text": "As you defeat the nightmares and rescue the monks, my powers will grow.",
			"character": "yume",
		},
		{
			"text": "For now, all I have to offer you is this gun.",
			"character": "yume",
		},
		{
			"animation": "17 - Get Shotgun"
		}
	],
	"17 - Get Shotgun": [ 
		{
			"text": "Oh my god! Er, oh my [color=#1b5c84]Yume[/color]? Is this a friggen shotgun?",
			"character": "player",
		},
		{
			"text": "Yes. I grant you this holy shotgun, may it serve you well in your fight against the nightmares.",
			"character": "yume",
		},
		{
			"text": "But how do I bring it with me into the nightmare?",
			"character": "player",
		},
		{
			"text": "You should be strong enough already to bring [b]one gun[/b] with you when you dreamwalk.",
			"character": "yume",
		},
		{
			"text": "As your power grows, you may be able to take more.",
			"character": "yume",
		},
		{
			"text": "This is amazing! There's no way I'll lose with this bad boy at my side!",
			"character": "player",
		},
		{
			"text": "Temper your overconfidence child, the nightmares you are about to face are both powerful and dangerous.",
			"character": "yume",
		},
		{
			"text": "You may not defeat them on your first try.",
			"character": "yume",
		},
		{
			"text": "What do you mean by first try?",
			"character": "player",
		},
		{
			"text": "I'm sorry, I am already losing connection to the mortal realm.",
			"character": "yume",
		},
		{
			"text": "Rescue Midori, defeat his nightmare, then I will be able to return.",
			"character": "yume",
		},
		{
			"text": "[color=#1b5c84]Yume[/color]? [color=#1b5c84]Yume[/color]?",
			"character": "player",
		},
		{
			"text": "Of course... [color=#1b5c84]She[/color] conveniently runs out of power before having to actually explain anything to me...",
			"character": "player",
		},
		{
			"text": "Well, best get started trying to free Midori then...",
			"character": "player",
		},
		{
			"end": true,
			"method": "on_meet_yume"
		}
	],
	"Offer to Fix": [
		{
			"text": "Welcome back kiddo! How was the first dive?",
			"character": "ki",
		},
		{
			"text": "To be honest, I feel a bit nauseous...",
			"character": "player",
		},
		{
			"text": "Well, I got something that'll perk ya right up!",
			"character": "ki",
		},
		{
			"text": "While you was sleepin', I put up some signs around the temple with the materials I'll need to fixerup!",
			"character": "ki",
		},
		{
			"text": "Couldn't you have used that wood to actually fix something instead of making signs?",
			"character": "player",
		},
		{
			"text": "Sign craftin is an age old tradition, gotta keep that skill nice 'n sharp, y'know?",
			"character": "ki",
		},
		{
			"text": "Sure...",
			"character": "player",
		},
		{
			"text": "Once you got the materials ya need, just interact with one of them signs and I'll fix it up in a jiffy!",
			"character": "ki",
		},
		{
			"animation": "Zoom to Gunforge",
			"skip": {
				"A": false,
				"B": true,
				"triggers": ["has_gone_outside"],
				"null_triggers": []
			},
		},
		{
			"text": {
				"A": "Alright, makes sense. Where am I supposed to get these materials? I can't get anymore wood from the sacred tree...",
				"B": "Alright, makes sense. Where am I supposed to get these materials?",
				"triggers": ["holy_tree_destroyed"],
				"null_triggers": []
			},
			"character": "player",
		},
		{
			"animation": "Zoom to Exit"
		}
	],
	"Zoom to Exit": [
		{
			"text": {
				"A": "People who aren't [b]MANIACS[/b] get there materials out in front of the temple.",
				"B": "You can get more materials from the forest in front of the temple.",
				"triggers": ["holy_tree_destroyed"],
				"null_triggers": []
			},
			"character": "ki",
		},
		{
			"text": "Look, you said you needed wood, and I-",
			"character": "player",
			"skip": {
				"A": false,
				"B": true,
				"triggers": ["holy_tree_destroyed"],
				"null_triggers": []
			}
		},
		{
			"text": "In here, [color=#1b5c84]Yume's[/color] blessin' keeps time standin' still.",
			"character": "ki",
		},
		{
			"text": "Once you go out the front doors, you'll only have a limited amounta daylight to getcher goodies.",
			"character": "ki",
		},
		{
			"text": "Make sure you move quickly, ya wanna be back at the temple by nightfall, before the nightmares get here.",
			"character": "ki",
		},
		{
			"text": "Got it. Move quickly, get back before nightfall.",
			"character": "player",
		},
		{
			"animation": "Zoom to Gunforge"
		}

	],
	"Zoom to Gunforge": [
		{
			"text": "I reckon the first thing ya should fix up is the old Gunforge.",
			"character": "ki",
		},
		{
			"text": "Once the Gunsmith smells the forge, I'm sure he'll come back.",
			"character": "ki",
		},
		{
			"end": true,
			"method": "on_offer_to_fix"
		}
	],
	"Build Gunforge": [
		{
			"text": "IS THAT THE RED HOT COALS OF A GUNFORGE THAT I SMELL?!",
			"character": "kajiya",
			"method": "kajiya_theme"
		},
		{
			"animation": "Kajiya Entrance"
		}
	],
	"Kajiya Entrance": [
		{
			"text": "SOMEONE ACTUALLY MANAGED TO FIX THE GUNFORGE?! INCREDIBLE!",
			"character": "kajiya",
		},
		{
			"text": "AH, IT'S BEEN SO LONG SINCE I LAST FORGED! YOUNG APPRENTICE, ARE YOU READY TO LEARN THE WAYS OF THE FORGE?",
			"character": "kajiya",
		},
		{
			"animation": "Kajiya Walk to Forge"
		}
	],
	"Kajiya Walk to Forge": [
		{
			"text": "Wait, me? I already have a lot on my plate, so-",
			"character": "player",
		},
		{
			"text": "WE BEGIN IMMEDIATELY! FETCH ME TWO MATERIALS SO WE CAN FIX YOUR AWFUL SHOTGUN ASAP!",
			"character": "kajiya",
		},
		{
			"text": "I reckon you best do what he says. He's quite excitable...",
			"character": "ki",
		},
		{
			"text": "COME INTERACT WITH THE ANVIL WHEN YOU'RE READY APPRENTICE!",
			"character": "kajiya",
		},
		{
			"end": true,
			"method": "on_unlock_gunsmithing"
		}
	],
	"On First Anvil": [
		{
			"text": "THIS IS A COMPLEX AND TECHNICAL ART APPRENTICE, SO MAKE SURE YOU PAY ATTENTION!",
			"character": "kajiya",
		},
		{
			"text": "FIRST, SELECT A SCHEMATIC FROM THE TOP! I'LL LET YOU USE MY SHOTGUN SCHEMATIC FOR FREE!",
			"character": "kajiya",
		},
		{
			"text": "THEN, SELECT THE PARTS YOU WANT TO BUILD WITH FROM THE LEFT!",
			"character": "kajiya",
		},
		{
			"text": "DIFFERENT PARTS WILL GIVE YOUR GUN DIFFERENT MODIFICATIONS!",
			"character": "kajiya",
		},
		{
			"text": "TRY OUT DIFFERENT MATERIALS TO SEE WHAT WORKS BEST!",
			"character": "kajiya",
		},
		{
			"text": "ONCE YOU'RE SATISFIED, HIT MAKE AND ENJOY YOUR NEW GUN! YOU CAN SEE ALL OF YOUR GUNS IN THE NEARBY GUN CHEST!",
			"character": "kajiya",
		},
		{
			"text": "YOU'LL FIND MORE SCHEMATICS AND MATERIALS WHILE YOU'RE RESCUING THE MONKS, SO COME BACK OFTEN!",
			"character": "kajiya",
		},
		{
			"end": true,
			"keep_paused": true
		}
	],
	"Sensei": [
		{
			"text": "Shhh, I'm not supposed to be here yet!",
			"character": "sensei"
		},
		{
			"end": true
		}
	]
}

func connect_to_player(curr_player):
	player = curr_player
	dialog_man = get_node("Dialog")
	animator = get_node("Cutscene Animator")
	globals = get_node("/root/Globals")

	dialog_man.connect("next", self, "_dialog_continue")
	animator.connect("animation_finished", self, "_animation_finished")

	if !globals.cutscenes.intro:
		is_in_cutscene = true
		get_node("Cutscene Camera").current = true
		get_node("../Players").visible = false
		self.visible = true

		animator.play("1 - Character Waking Up")
		get_tree().paused = true
	elif globals.get_trigger("entered_midori_dream") && !globals.cutscenes.offer_to_fix:
		get_node("../Players").visible = false
		start_cutscene("Offer to Fix")
	elif globals.get_trigger("has_gone_outside") && !globals.get_trigger("built-prophecy_chamber") && globals.inventory.wood >= 1:
		globals.inventory.wood -= 1
		start_cutscene("11 - Got Wood")
	else:
		self.visible = false

func tree_killed():
	start_cutscene("11 - Tree Killed")

func set_tree_killed():	
	globals.set_trigger("holy_tree_destroyed", true)


func _animation_finished(anim):
	if dialog.has(anim):
		start_dialog(anim)

func start_dialog(dialog):
	get_tree().paused = true
	last_anim = dialog
	dialog_man.visible = true
	dialog_i = -1
	_dialog_continue()

func _dialog_continue():
	var next_dialog = dialog[last_anim][dialog_i + 1]
	for v in next_dialog:
		if typeof(next_dialog[v]) == TYPE_DICTIONARY:
			var dict = next_dialog[v]
			next_dialog[v] = _select_trigger(dict.A, dict.B, dict.triggers, dict.null_triggers)

	if next_dialog.has("skip") && next_dialog.skip:
		dialog_i +=1
		_dialog_continue()
	elif next_dialog.has("end") && next_dialog.end:
		is_in_cutscene = false
		normal_theme()
		dialog_man.visible = false
		self.visible = false
		
		get_node("Cutscene Camera").current = false
		get_node("../Players").visible = true
		if !next_dialog.has("keep_paused"):
			get_tree().paused = false
		player.get_node("Camera").current = true
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

func _select_trigger(A, B, triggers = [], null_triggers = []):
	var return_option = A
	if len(triggers):
		for t in triggers:
			if !globals.get_trigger(t):
				return_option = B

	if len(null_triggers):
		for t in null_triggers:
			if globals.get_trigger(t):
				return_option = B
	
	return return_option

func on_build(building):
	match building:
		"gunforge":
			start_cutscene("Build Gunforge")

func intro_end():
	var player_pos = get_node("Sprites/Player Animator").global_position
	player.global_position.x = player_pos.x
	player.global_position.y = player_pos.y
	
	get_node("Sprites/Player Animator").visible = false

	var ki = get_node("../NPCs/Ki")
	ki.on_animation_end()

func prophecy_chamber_rebuilt():
	globals.set_trigger("built-prophecy_chamber", true)

func unlock_midori_bed():
	globals.set_trigger("bed_unlocked-midori", true)

func on_meet_yume():
	globals.set_trigger("has_shotgun", true)
	var gun_man = get_node("/root/GunManager")
	gun_man.current_gun = 1

func on_prophecy_read():
	globals.cutscenes.prophecy = true
	start_cutscene("13 - Read Prophecy")

func on_first_dive():
	globals.cutscenes.on_first_dive = true
	globals.set_trigger("yume_unlocked", true)
	start_cutscene("15 - On First Dive")

func on_first_yume_interaction():
	start_cutscene("16 - Meet Yume")

func on_offer_to_fix():
	globals.cutscenes.offer_to_fix = true

	var player_pos = get_node("Sprites/Player Animator").global_position
	player.global_position.x = player_pos.x
	player.global_position.y = player_pos.y
	
	get_node("Sprites/Player Animator").visible = false

func on_unlock_gunsmithing():
	globals.set_trigger("gunsmithing_unlocked", true)

func on_first_anvil():
	is_in_cutscene = true
	_animation_finished("On First Anvil")

func ki_entrance():
	play_door()
	ki_theme()

func ki_theme():
	get_parent().get_node("BG Music").stream = load("res://assets/audio/Ki Theme.wav")
	get_parent().get_node("BG Music").play()

func kajiya_theme():
	get_parent().get_node("BG Music").stream = load("res://assets/audio/Kajiya Theme.wav")
	get_parent().get_node("BG Music").play()

func normal_theme():
	if get_parent().get_node("BG Music").stream != load("res://assets/audio/songs/Town.wav"):
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

func start_cutscene(cutscene):
	player.get_node("How to Interact/Pop Up").modulate = "#00000000"

	var curr_cam = player.get_node("Camera")
	get_node("Cutscene Camera").global_position = curr_cam.global_position
	get_node("Cutscene Camera").zoom = curr_cam.zoom
	get_node("Cutscene Camera").current = true

	self.visible = true

	get_tree().paused = true
	animator.play(cutscene)
	is_in_cutscene = true
