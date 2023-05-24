extends Node2D
var CardScene = preload("res://card.tscn")
var Cards = preload("res://card.gd")
var UI = preload("res://UI.tscn")
var CardsEnum = Cards.Cards
var Power = Cards.Power
var Art = Cards.Art

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
var monsterhp = 20

# node to represent card (make copies manually)

var deck = []
var hand = []

@onready var game_board = get_node("/root/GameBoard")
func _ready():
	var NewUI = UI.instantiate()
	game_board.add_child(NewUI)
	rng.randomize()
	
	for i in 8:
		for Card in CardsEnum:
			deck.append(Card)
	
	print("deck",deck)
	print("we're starting")
	
	for i in 3:
		var idx = rng.randi_range(0,deck.size()-1)
		hand.append(deck[idx])
		deck.remove_at(idx)
	
	#print("hand",hand)
	#print(hand[2])
	var testcard = hand[2]
	#print("power",Cards.Power[CardsEnum.get(testcard)])
	
	
	for i in 3:
		var card = CardScene.instantiate()
		card.reveal()
		card.cardplayed.connect(play_card)
		var card_type = hand[i]
		card.set_card_type(card_type)
		game_board.add_child(card)
		cardNodes.append(card)
		card.position = Vector2((i*200)+350,525)
		print(card.position)

func _process(delta):
	#$Label.text = "monster health: " + str(monsterhp)
	if monsterhp <= 0:
		curstate = State.END
		print("GG PLAYER!")
	
	if playerhp <= 0:
		curstate = State.END
		print("Better luck next time")

func play_card(card):
	if curstate == State.PLAYER1_PLAY:
		var idx = hand.find(card)
		print("gklahglkdjafklsajf", card.position)
		monsterhp -= Power[card.get_card_type(card)]
		playpos = card.position
		spawn_card()

func spawn_card():
	var card = CardScene.instantiate()
	card.reveal()
	if deck.size() != 0:
		if deck.size() == 1:
			var idx = 0
			card.cardplayed.connect(play_card)
			var card_type = deck[idx]
			deck.remove_at(idx)
			card.set_card_type(card_type)
			game_board.add_child(card)
			cardNodes.append(card)
			card.position = playpos
			print("you're decked")
		else:
			var idx = rng.randi_range(0,deck.size()-2)
			card.cardplayed.connect(play_card)
			var card_type = deck[idx]
			deck.remove_at(idx)
			card.set_card_type(card_type)
			game_board.add_child(card)
			cardNodes.append(card)
			card.position = playpos

func draw_card():
	hand.append(deck[0])
	deck.remove_at(0)
	pass

func next_state():
	if curstate == State.PLAYER1_DRAW:
		print("player 1 drawing")
		#draw_card()
		switch_states(State.PLAYER1_PLAY)
	elif curstate == State.PLAYER1_PLAY:
		switch_states(State.MONSTERTURN)
		print("player 1 playing cards now")
	elif curstate == State.MONSTERTURN:
		print("MONSTER TURN!!")
		switch_states(State.PLAYER1_DRAW)
	elif curstate == State.END:
		print("game over!")

func switch_states(new_state: State):
	curstate = new_state
	state_time = 0.0
	
	if new_state == State.BEGIN:
		print("we're starting")
	elif new_state == State.DEAL:
		print("drawing hand cards")
	elif new_state == State.PLAYER1_DRAW:
		print("player 1 drawing")
		#spawn_card()
		switch_states(State.PLAYER1_PLAY)
	elif new_state == State.PLAYER1_PLAY:
		print("player 1 playing cards now")
	elif new_state == State.MONSTERTURN:
		# monster does damage to the player
		playerhp -= 4
		print("playerhealth: ", playerhp)
		switch_states(State.PLAYER1_DRAW)
		print("player 2 drawing")
	elif new_state == State.END:
		print("game over!")
