extends Node2D
var CardScene = preload("res://card.tscn")
var Cards = preload("res://card.gd")
var CardsEnum = Cards.Cards
var Power = Cards.Power
var Art = Cards.Art

enum State {BEGIN, DEAL, PLAYER1_DRAW, PLAYER1_PLAY, MONSTERTURN, END}
var curstate = State.BEGIN
var state_time = 0.0
var playpos
var cardNodes = []
var rng = RandomNumberGenerator.new()

var playerhp = 20
var monsterhp = 20

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
	
	for i in 5:
		var idx = rng.randi_range(0,deck.size()-1)
		hand.append(deck[idx])
		deck.remove_at(idx)
	
	print("hand",hand)
	print(hand[2])
	var testcard = hand[2]
	#print("power",Cards.Power[CardsEnum.get(testcard)])
	
	
	for i in 5:
		var card = CardScene.instantiate()
		card.cardplayed.connect(play_card)
		var card_type = hand[i]
		card.set_card_type(card_type)
		add_child(card)
		cardNodes.append(card)
		card.position = Vector2((i*200)+175,525)
		print(card.position)

func _process(delta):
	$Label.text = "monster health: " + str(monsterhp)
	if monsterhp <= 0:
		print("GGWP")

func play_card(card):
	var idx = hand.find(card)
	print("gklahglkdjafklsajf", card.position)
	monsterhp -= Power[card.get_card_type(card)]
	playpos = card.position
	spawn_card()

func spawn_card():
	var card = CardScene.instantiate()
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

func switch_states(new_state: State):
	curstate = new_state
	state_time = 0.0
	
	if new_state == State.BEGIN:
		print("we're starting")
	elif new_state == State.DEAL:
		print("drawing hand cards")
	elif new_state == State.PLAYER1_DRAW:
		print("player 1 drawing")
		#draw_card()
		switch_states(State.PLAYER1_PLAY)
	elif new_state == State.PLAYER1_PLAY:
		print("player 1 playing cards now")
	elif new_state == State.MONSTERTURN:
		print("player 2 drawing")
	elif new_state == State.END:
		print("game over!")
