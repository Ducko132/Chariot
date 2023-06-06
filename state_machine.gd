extends Node2D
var CardScene = preload("res://card.tscn")
var Cards = preload("res://card.gd")
var UI = preload("res://UI.tscn")
var gameboard = preload("res://game_board.tscn")
var tutorial = preload("res://tutorial.tscn")
var gameboard2 = preload("res://game_board_2.tscn")
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

var deck = []
var truedeck = []
var hand = []
var pickarray = []

var game_board = null

func _ready():
	for Card in CardsEnum:
		pickarray.append(Card)
	pass

func start_game(i):
	GameLevel = i
	print("GameLevel:",GameLevel)
	switch_states(State.PLAYER1_DRAW)
	
	if game_board != null:
		game_board.queue_free()
	pickCount = 2
	
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
	if curstate == State.PLAYER1_DRAW:
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
					playerhp -= 3
					curmonstermove = "small attack (3dmg)"
				elif rand == 2:
					playerhp -= 3
					curmonstermove = "small attack (4dmg)"
				elif rand == 3:
					playerhp -= 4
					curmonstermove = "medium attack (4dmg)"
			elif monsterhp >= 10:
				var rand = rng.randi_range(1,3)
				print("rand",rand)
				if rand == 1:
					monsterhp += 5
					curmonstermove = "heal (+5hp)"
				elif rand == 2:
					playerhp -= 5
					curmonstermove = "heavy attack (5dmg)"
				elif rand == 3:
					playerhp -= 3
					monsterhp += 3
					curmonstermove = "monster uses life drain (3dmg, +3hp)"
			elif monsterhp >= 5:
				var rand = rng.randi_range(1,3)
				print("rand",rand)
				if rand == 1:
					monsterhp += 7
					playerhp -= 2
					curmonstermove = "monster uses heal-drain (2dmg, +7hp)"
				elif rand == 2:
					monsterhp += 5
					playerhp -= 4
					curmonstermove = "monster uses it's vampiric bite (5dmg, +4hp)"
				elif rand == 3:
					playerhp -= 10
					curmonstermove = "it's final gambit. (10dmg)"
			elif monsterhp >= 1 and monster2ndchance:
				monster2ndchance = false
				monsterhp += 40
				curmonstermove = "MONSTER USES IT'S 2ND CHANCE (+40hp)"
			else:
				monsterhp += 5
				playermana -= 5
				curmonstermove = "monster tries to recover (+5hp, -5mana)"
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
					curmonstermove = "small attack (4dmg)"
				elif rand == 3:
					playerhp -= 4
					curmonstermove = "medium attack (4dmg)"
			elif monsterhp >= 10:
				var rand = rng.randi_range(1,3)
				print("rand",rand)
				if rand == 1:
					monsterhp += 5
					curmonstermove = "heal (+5hp)"
				elif rand == 2:
					playerhp -= 5
					curmonstermove = "heavy attack (5dmg)"
				elif rand == 3:
					playerhp -= 3
					monsterhp += 3
					curmonstermove = "monster uses life drain (3dmg, +3hp)"
			elif monsterhp >= 5:
				var rand = rng.randi_range(1,3)
				print("rand",rand)
				if rand == 1:
					monsterhp += 7
					playerhp -= 2
					curmonstermove = "monster uses heal-drain (2dmg, +7hp)"
				elif rand == 2:
					monsterhp += 5
					playerhp -= 4
					curmonstermove = "monster uses it's vampiric bite (5dmg, +4hp)"
				elif rand == 3:
					playerhp -= 10
					curmonstermove = "it's final gambit. (10dmg)"
			elif monsterhp >= 1 and monster2ndchance:
				monster2ndchance = false
				monsterhp += 40
				curmonstermove = "MONSTER USES IT'S 2ND CHANCE (+40hp)"
			else:
				monsterhp += 5
				playermana -= 5
				curmonstermove = "monster tries to recover (+5hp, -5mana)"
		if GameLevel == 2:
			print("level two monster")
			if monsterhp >= 20:
				var rand = rng.randi_range(1,3)
				print("rand",rand)
				if rand == 1:
					playerhp -= 3
					curmonstermove = "small attack (3dmg)"
				elif rand == 2:
					playerhp -= 3
					curmonstermove = "small attack (4dmg)"
				elif rand == 3:
					playerhp -= 4
					curmonstermove = "medium attack (4dmg)"
			elif monsterhp >= 10:
				var rand = rng.randi_range(1,3)
				print("rand",rand)
				if rand == 1:
					monsterhp += 5
					curmonstermove = "heal (+5hp)"
				elif rand == 2:
					playerhp -= 5
					curmonstermove = "heavy attack (5dmg)"
				elif rand == 3:
					playerhp -= 3
					monsterhp += 3
					curmonstermove = "monster uses life drain (3dmg, +3hp)"
			elif monsterhp >= 5:
				var rand = rng.randi_range(1,3)
				print("rand",rand)
				if rand == 1:
					monsterhp += 7
					playerhp -= 2
					curmonstermove = "monster uses heal-drain (2dmg, +7hp)"
				elif rand == 2:
					monsterhp += 5
					playerhp -= 4
					curmonstermove = "monster uses it's vampiric bite (5dmg, +4hp)"
				elif rand == 3:
					playerhp -= 10
					curmonstermove = "it's final gambit. (10dmg)"
			elif monsterhp >= 1 and monster2ndchance:
				monster2ndchance = false
				monsterhp += 40
				curmonstermove = "MONSTER USES IT'S 2ND CHANCE (+40hp)"
			else:
				monsterhp += 5
				playermana -= 5
				curmonstermove = "monster tries to recover (+5hp, -5mana)"
		if GameLevel == 3:
			print("level three boss")
			if monsterhp >= 20:
				var rand = rng.randi_range(1,3)
				print("rand",rand)
				if rand == 1:
					playerhp -= 3
					curmonstermove = "small attack (3dmg)"
				elif rand == 2:
					playerhp -= 3
					curmonstermove = "small attack (4dmg)"
				elif rand == 3:
					playerhp -= 4
					curmonstermove = "medium attack (4dmg)"
			elif monsterhp >= 10:
				var rand = rng.randi_range(1,3)
				print("rand",rand)
				if rand == 1:
					monsterhp += 5
					curmonstermove = "heal (+5hp)"
				elif rand == 2:
					playerhp -= 5
					curmonstermove = "heavy attack (5dmg)"
				elif rand == 3:
					playerhp -= 3
					monsterhp += 3
					curmonstermove = "monster uses life drain (3dmg, +3hp)"
			elif monsterhp >= 5:
				var rand = rng.randi_range(1,3)
				print("rand",rand)
				if rand == 1:
					monsterhp += 7
					playerhp -= 2
					curmonstermove = "monster uses heal-drain (2dmg, +7hp)"
				elif rand == 2:
					monsterhp += 5
					playerhp -= 4
					curmonstermove = "monster uses it's vampiric bite (5dmg, +4hp)"
				elif rand == 3:
					playerhp -= 10
					curmonstermove = "it's final gambit. (10dmg)"
			elif monsterhp >= 1 and monster2ndchance:
				monster2ndchance = false
				monsterhp += 40
				curmonstermove = "MONSTER USES IT'S 2ND CHANCE (+40hp)"
			else:
				monsterhp += 5
				playermana -= 5
				curmonstermove = "monster tries to recover (+5hp, -5mana)"
		switch_states(State.PLAYER1_DRAW)
		print("MONSTER TURN")
	elif new_state == State.END && GameLevel != 0:
		if playerhp <= 0:
			print("you lost")
			await get_tree().create_timer(1).timeout
			#for child in game_board.get_children():
			#	child.visible = false
			get_tree().change_scene_to_file("res://main_menu.tscn")
		else:
			rng.randomize()
			for child in game_board.get_children():
				child.visible = false
			
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
		
