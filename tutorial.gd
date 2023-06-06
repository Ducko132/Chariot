extends Node2D
var CardScene = preload("res://card.tscn")
var Cards = preload("res://card.gd")
var UI = preload("res://UI.tscn")
var gameboard = preload("res://game_board.tscn")
var CardsEnum = Cards.StarterCards
var Cost = Cards.Cost
var Power = Cards.Power
var Heal = Cards.Heal
var Mana = Cards.ManaPerTurn
var Art = Cards.Art
var IsCont = Cards.ContCard
signal monsterhplost
var playpos
var cardNodes = []
var rng = RandomNumberGenerator.new()
var monster2ndchance = true
var curmonstermove
var continuouscard

var hand = []
var tempdeck = []

func _ready():
	rng.randomize()
	
	for i in 5:
		for Card in CardsEnum:
			tempdeck.append(Card)
	
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

func play_card(card):
	if StateMachine.curstate == StateMachine.State.PLAYER1_PLAY:
		if IsCont[card.get_card_type(card)]:
			self.remove_child(card)
			$ContinuousCards.add_child(card)
			card.position = Vector2(0,0)
			pass
		else:
			@warning_ignore("unused_variable")
			var idx = hand.find(card)
			StateMachine.monsterhp -= Power[card.get_card_type(card)]
			StateMachine.playerhp += Heal[card.get_card_type(card)]
			StateMachine.manaperturn += Mana[card.get_card_type(card)]
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
