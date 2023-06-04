extends Node2D
var CardScene = preload("res://card.tscn")
var Cards = preload("res://card.gd")
var UI = preload("res://UI.tscn")
var gameboard = preload("res://game_board.tscn")
var CardsEnum = Cards.StarterCards
var Cost = Cards.Cost
var Power = Cards.Power
var Heal = Cards.Heal
var Art = Cards.Art
signal monsterhplost

#var MonsterCardsEnum = Cards.MonsterCards
#var MonsterPower = Cards.MonsterPower
#var MonsterArt = Cards.MonsterArt

var playpos
var cardNodes = []
var rng = RandomNumberGenerator.new()

#var monsterhp = 20
var monster2ndchance = true
var curmonstermove

# node to represent card (make copies manually)

var hand = []
var tempdeck

func _ready():
	rng.randomize()
	
	for i in 5:
		for Card in CardsEnum:
			StateMachine.deck.append(Card)
			tempdeck = StateMachine.deck
	print("deck",tempdeck)
	print("we're starting")
	
	for i in 3:
		var idx = rng.randi_range(0,tempdeck.size()-1)
		hand.append(tempdeck[idx])
		tempdeck.remove_at(idx)
	
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

@warning_ignore("unused_parameter")
func _process(delta):
	if StateMachine.monsterhp <= 0:
		get_tree().change_scene_to_file("res://main_menu.tscn")
		self.queue_free()
		#print("GG PLAYER!")

func play_card(card):
	if StateMachine.curstate == StateMachine.State.PLAYER1_PLAY:
		@warning_ignore("unused_variable")
		var idx = hand.find(card)
		print("gklahglkdjafklsajf", card.position)
		StateMachine.monsterhp -= Power[card.get_card_type(card)]
		StateMachine.playerhp += Heal[card.get_card_type(card)]
		if Power[card.get_card_type(card)] > 0:
			monsterhplost.emit()
		playpos = card.position
		spawn_card()

func spawn_card():
	var card = CardScene.instantiate()
	card.reveal()
	if tempdeck.size() != 0:
		if tempdeck.size() == 1:
			var idx = 0
			card.cardplayed.connect(play_card)
			var card_type = tempdeck[idx]
			tempdeck.remove_at(idx)
			card.set_card_type(card_type)
			add_child(card)
			cardNodes.append(card)
			card.position = playpos
			print("you're decked")
		else:
			var idx = rng.randi_range(0,tempdeck.size()-2)
			card.cardplayed.connect(play_card)
			var card_type = tempdeck[idx]
			tempdeck.remove_at(idx)
			card.set_card_type(card_type)
			add_child(card)
			cardNodes.append(card)
			card.position = playpos

func draw_card():
	hand.append(tempdeck[0])
	tempdeck.remove_at(0)
	pass
