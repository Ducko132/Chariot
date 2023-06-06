extends Node2D
var CardScene = preload("res://card.tscn")
var Cards = preload("res://card.gd")
var UI = preload("res://UI.tscn")
var gameboard = preload("res://game_board.tscn")
var tutorial = preload("res://tutorial.tscn")
var gameboard2 = preload("res://game_board_2.tscn")
var gameboard3 = preload("res://game_board_3.tscn")
var CardsEnum = Cards.Cards
var Cost = Cards.Cost
var Power = Cards.Power
var Art = Cards.Art
var GameLevel
signal monsterhplost
signal monsterturn
var pickCount = 2
var amplifier

#var MonsterCardsEnum = Cards.MonsterCards
#var MonsterPower = Cards.MonsterPower
#var MonsterArt = Cards.MonsterArt

enum State {BEGIN, DEAL, PLAYER1_DRAW, PLAYER1_PLAY, MONSTERTURN, END}
@export var curstate = State.PLAYER1_DRAW
var state_time = 0.0
var playpos
var cardNodes = []
var rng = RandomNumberGenerator.new()

var playerhp = 20
var playermana = 4
var manaperturn = 1

var monsterhp = 20
var monster2ndchance = true
var curmonstermove

# node to represent card (make copies manually)
var UITEMP = null
var deck = []
var truedeck = []
var hand = []
var pickarray = []
var strength = 0
var game_board = null

func _ready():
	for Card in CardsEnum:
		pickarray.append(Card)
	pass

func start_game(i):
	GameLevel = i
	print("GameLevel:",GameLevel)
	
	if game_board != null:
		game_board.queue_free()
	pickCount = 2
	switch_states(State.BEGIN)
	
	if i == 0:
		manaperturn = 1
		playermana = 4
		monsterhp = 20
		playerhp = 20
		game_board = tutorial.instantiate()
		get_parent().add_child(game_board)
		print("tutorial instantiated")
		var NewUI = UI.instantiate()
		game_board.add_child(NewUI)
	elif i == 1:
		manaperturn = 1
		playermana = 4
		monsterhp = 20
		playerhp = 20
		game_board = gameboard.instantiate()
		get_parent().add_child(game_board)
		print("level 1 instantiated")
		var NewUI = UI.instantiate()
		game_board.add_child(NewUI)
	elif i == 2:
		manaperturn = 1
		playermana = 4
		monsterhp = 30
		playerhp = 20
		game_board = gameboard2.instantiate()
		print(get_parent())
		get_parent().add_child(game_board)
		print("level 2 instantiated")
		var NewUI = UI.instantiate()
		game_board.add_child(NewUI)
	elif i == 3:
		manaperturn = 1
		playermana = 4
		monsterhp = 30
		playerhp = 20
		game_board = gameboard3.instantiate()
		print(get_parent())
		get_parent().add_child(game_board)
		print("level 3 instantiated")
		var NewUI = UI.instantiate()
		game_board.add_child(NewUI)

func _process(delta):
	if monsterhp <= 0 && curstate != State.END:
		curstate = State.END
		switch_states(State.END)
		print("GG PLAYER!")
	
	if playerhp <= 0 && curstate != State.END:
		curstate = State.END
		switch_states(State.END)
		print("Better luck next time")

func next_state():
	if curstate == State.BEGIN:
		switch_states(State.PLAYER1_PLAY)
	elif curstate == State.PLAYER1_DRAW:
		print("player 1 drawing")
		switch_states(State.PLAYER1_PLAY)
	elif curstate == State.PLAYER1_PLAY:
		switch_states(State.MONSTERTURN)
		print("player 1 playing cards now")
	elif curstate == State.MONSTERTURN:
		print("MONSTER TURN!!")
		switch_states(State.PLAYER1_DRAW)
	elif curstate == State.END:
		print("game over!")

func get_deck():
	return deck

func set_true_deck(deck):
	truedeck = deck

func switch_states(new_state: State):
	curstate = new_state
	state_time = 0.0
	
	if new_state == State.BEGIN:
		print("we're starting")
	elif new_state == State.DEAL:
		print("drawing hand cards")
	elif new_state == State.PLAYER1_DRAW:
		print("player 1 drawing")
		switch_states(State.PLAYER1_PLAY)
		playermana += manaperturn
		manaperturn += 1
	elif new_state == State.PLAYER1_PLAY:
		print("player 1 playing cards now")
	elif new_state == State.MONSTERTURN:
		if GameLevel == 0:
			print("tutorial monster")
			if monsterhp >= 20:
				var rand = rng.randi_range(1,3)
				print("rand",rand)
				if rand == 1:
					playerhp -= 2
					curmonstermove = "small attack (2dmg)"
				elif rand == 2:
					playerhp -= 2
					curmonstermove = "small attack (2dmg)"
				elif rand == 3:
					playerhp -= 2
					curmonstermove = "medium attack (2dmg)"
			elif monsterhp >= 10:
				var rand = rng.randi_range(1,3)
				print("rand",rand)
				if rand == 1:
					monsterhp += 3
					curmonstermove = "heal (+3hp)"
				elif rand == 2:
					playerhp -= 3
					curmonstermove = "heavy attack (3dmg)"
				elif rand == 3:
					playerhp -= 2
					monsterhp += 2
					curmonstermove = "monster uses life drain (2dmg, +2hp)"
			elif monsterhp >= 5:
				var rand = rng.randi_range(1,3)
				print("rand",rand)
				if rand == 1:
					monsterhp += 3
					playerhp -= 3
					curmonstermove = "monster uses heal-drain (3dmg, +3hp)"
				elif rand == 2:
					monsterhp += 3
					playerhp -= 3
					curmonstermove = "monster uses heal-drain (3dmg, +3hp)"
				elif rand == 3:
					playerhp -= 5
					curmonstermove = "it's final move. (5dmg)"
		if GameLevel == 1:
			print("level one monster")
			if monsterhp >= 20:
				var rand = rng.randi_range(1,3)
				print("rand",rand)
				if rand == 1:
					playerhp -= 3
					curmonstermove = "small attack (3dmg)"
				elif rand == 2:
					playerhp -= 3
					curmonstermove = "small attack (3dmg)"
				elif rand == 3:
					playerhp -= 3
					curmonstermove = "small attack (3dmg)"
			elif monsterhp >= 10:
				var rand = rng.randi_range(1,3)
				print("rand",rand)
				if rand == 1:
					monsterhp += 5
					curmonstermove = "monster uses replenish (+5hp)"
				elif rand == 2:
					playerhp -= 5
					curmonstermove = "cyclops lunges in and swings (5dmg)"
				elif rand == 3:
					playerhp -= 3
					monsterhp += 3
					curmonstermove = "monster uses life drain (3dmg, +3hp)"
			elif monsterhp >= 5:
				var rand = rng.randi_range(1,3)
				print("rand",rand)
				if rand == 1:
					monsterhp += 5
					curmonstermove = "monster uses heal (+5 hp)"
				elif rand == 2:
					manaperturn -= 1 
					curmonstermove = "Monster uses mana drain (-1 manaperturn)"
				elif rand == 3:
					playerhp -= 8
					monsterhp -= 2
					curmonstermove = "monster uses eyesore (8dmg, -2hp)"
			elif monsterhp >= 1 and monster2ndchance:
				monster2ndchance = false
				monsterhp += 10
				curmonstermove = "Second Wind (+10hp)"
			else:
				monsterhp += 5
				manaperturn -= 5
				curmonstermove = "monster tries to recover (+5hp, -5 manaperturn)"
		if GameLevel == 2:
			print("level two monster: achilles")
			if monsterhp >= 20:
				var rand = rng.randi_range(1,3)
				print("rand",rand)
				if rand == 1:
					playerhp -= 4
					curmonstermove = "spear stab (4dmg)"
				elif rand == 2:
					playerhp -= 4
					curmonstermove = "spear stab (4dmg)"
				elif rand == 3:
					playerhp -= 4
					monsterhp += 1
					curmonstermove = "shield bash (4dmg, +1hp)"
			elif monsterhp >= 10:
				var rand = rng.randi_range(1,3)
				print("rand",rand)
				if rand == 1:
					monsterhp += 5
					curmonstermove = "fortify (+5hp)"
				elif rand == 2:
					playerhp -= 6
					curmonstermove = "swiftslash (6dmg)"
				elif rand == 3:
					playerhp -= 3
					monsterhp += 3
					curmonstermove = "leeching blockade (3dmg, +3hp)"
			elif monsterhp >= 5:
				var rand = rng.randi_range(1,3)
				print("rand",rand)
				if rand == 1:
					monsterhp += 7
					playerhp -= 1
					curmonstermove = "castle (1dmg, +7hp)"
				elif rand == 2:
					playerhp -= 8
					monsterhp -= 2
					curmonstermove = "spear dance (8dmg, -2hp)"
				elif rand == 3:
					playerhp -= 10
					curmonstermove = "close combat. (10dmg)"
			elif monsterhp >= 1 and monster2ndchance:
				monster2ndchance = false
				monsterhp += 15
				curmonstermove = "2nd wind (+15hp)"
			else:
				monsterhp += 10
				playermana -= 3
				curmonstermove = "iron defense drain (+10hp, -3mana)"
		if GameLevel == 3:
			print("level three boss: Ares")
			if monsterhp >= 20:
				var rand = rng.randi_range(1,3)
				#print("rand",rand)
				if rand == 1:
					strength += 1
					curmonstermove = "train (strength++) Current Strength:" + str(strength)
				elif rand == 2:
					playerhp -= 2 + strength
					curmonstermove = "light punch (2dmg)"
				elif rand == 3:
					playerhp -= 1 + strength
					strength += 1
					curmonstermove = "boxing bullet (1dmg, strength++) Current Strength:" + str(strength)
			elif monsterhp >= 10:
				var rand = rng.randi_range(1,3)
				#print("rand",rand)
				if rand == 1:
					playermana = 0
					curmonstermove = "grand disarm (player mana = 0)"
				elif rand == 2:
					strength += 2
					curmonstermove = "war god's thunder (strength += 2)  Current Strength:" + str(strength)
				elif rand == 3:
					playerhp -= ((1+strength)*2)
					curmonstermove = "fury blows (1 dmg two times, each affected by strength) Current Strength:" + str(strength)
			elif monsterhp >= 5:
				var rand = rng.randi_range(1,3)
				#print("rand",rand)
				if rand == 1:
					monsterhp += (3 * strength)
					curmonstermove = "offense is the best defense (+(strength*3)hp) Current Strength:" + str(strength)
				elif rand == 2:
					playerhp -= ((1*strength)*5)
					curmonstermove = "flurry blows (1 damage 5 times, each affected by strength) Current Strength:" + str(strength)
				elif rand == 3:
					monsterhp -= 4
					curmonstermove = "gamble (-5hp)"
			elif monsterhp >= 1 and monster2ndchance:
				monster2ndchance = false
				monsterhp += 20
				curmonstermove = "2nd wind (+20hp)"
			else:
				monsterhp += 8
				curmonstermove = "recovery (+8hp)"
		switch_states(State.PLAYER1_DRAW)
		print("MONSTER TURN")
	elif new_state == State.END && GameLevel != 0:
		if playerhp <= 0:
			print("you lost")
			await get_tree().create_timer(1).timeout
			for child in game_board.get_children():
				#child.visible = false
				child.queue_free()
			get_tree().change_scene_to_file("res://main_menu.tscn")
		elif GameLevel == 3:
			await get_tree().create_timer(1).timeout
			print("GGWP!!!! YOU BEAT THE GAME!")
			for child in game_board.get_children():
				#child.visible = false
				child.queue_free()
			get_tree().change_scene_to_file("res://victoryscreen.tscn")
			pass
		else:
			rng.randomize()
			for child in game_board.get_children():
				#child.visible = false
				child.queue_free()
			for i in 3:
				var card = CardScene.instantiate()
				card.reveal()
				var rand = rng.randi_range(0,4)
				var card_type = pickarray[rand]
				card.set_card_type(card_type)
				game_board.add_child(card)
				cardNodes.append(card)
				card.position = Vector2((i*200)+350,325)
				print(card.position)
		
