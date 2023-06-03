extends Node2D
var CardScene = preload("res://card.tscn")
var Cards = preload("res://card.gd")
var UI = preload("res://UI.tscn")
var gameboard = preload("res://game_board.tscn")
var CardsEnum = Cards.Cards
var Cost = Cards.Cost
var Power = Cards.Power
var Art = Cards.Art
signal monsterhplost

#var MonsterCardsEnum = Cards.MonsterCards
#var MonsterPower = Cards.MonsterPower
#var MonsterArt = Cards.MonsterArt

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
var hand = []

func _ready():
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
	#var testcard = hand[2]
	#print("power",Cards.Power[CardsEnum.get(testcard)])
	
	
	for i in 3:
		var card = CardScene.instantiate()
		card.reveal()
		card.cardplayed.connect(play_card)
		var card_type = hand[i]
		card.set_card_type(card_type)
		add_child(card)
		cardNodes.append(card)
		card.position = Vector2((i*200)+350,525)
		print(card.position)

func play_card(card):
	if StateMachine.curstate == StateMachine.State.PLAYER1_PLAY:
		var idx = hand.find(card)
		print("gklahglkdjafklsajf", card.position)
		monsterhp -= Power[card.get_card_type(card)]
		if Power[card.get_card_type(card)] > 0:
			monsterhplost.emit()
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
			add_child(card)
			cardNodes.append(card)
			card.position = playpos
			print("you're decked")
		else:
			var idx = rng.randi_range(0,deck.size()-2)
			card.cardplayed.connect(play_card)
			var card_type = deck[idx]
			deck.remove_at(idx)
			card.set_card_type(card_type)
			add_child(card)
			cardNodes.append(card)
			card.position = playpos

func draw_card():
	hand.append(deck[0])
	deck.remove_at(0)
	pass
