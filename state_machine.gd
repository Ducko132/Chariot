extends Node2D
var Cards = preload("res://card.gd")
var CardsEnum = Cards.Cards
var Power = Cards.Power
var Art = Cards.Art

enum State {BEGIN, DEAL, PLAYER1_DRAW, PLAYER1_PLAY, MONSTERTURN, END}
var curstate = State.BEGIN
var state_time = 0.0
var cardNodes = []
var rng = RandomNumberGenerator.new()

var playerhp = 20
var monsterhp = 20

# node to represent card (make copies manually)

var deck = []
var hand = [1,2,3]

func _ready():
	for i in 8:
		for Card in CardsEnum:
			deck.append(Card)
	
	print(deck)
	print("we're starting")
	
	for i in 5:
		hand.append(deck[0])
		deck.remove_at(0)
	
	print(hand)
	print(hand[6])
	var testcard = hand[6]
	# WOOOOO I FIGURED IT OUT
	print(Cards.Power[CardsEnum.get(testcard)])
	#load(Cards.Art[CardsEnum.get(hand[6])])
	#print(ctext)
	#add_child(cardex)
	
	
	for i in 3:
		#var c = load("res://card.tscn").instantiate()
		#var c = load(Cards.Art[CardsEnum.get(hand[6])]).instantiate()
		#var test = (c.find_child(str(CardsEnum.get(hand[6]))))
		#add_child(c)
		#cardNodes.append(c)
		#print(Cards.Power[CardsEnum.get(c)])
		#c.position = Vector2((i*400)+50,400)
		#c.find_child("Label").text = "value:" + str(hand[i])
		
		var sprite = Sprite2D.new()
		var texture = load(Cards.Art[CardsEnum.get(hand[6])])
		sprite.texture = texture
		add_child(sprite)
		cardNodes.append(sprite)
		sprite.position = Vector2((i*400)+50,400)
		

func _process(delta):
	#for i in cardNodes.size():
		#cardNodes[i].find_child("Label").text = "value:" + str(hand[i])
	pass

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


func _on_button_pressed():
	var cardt = hand[0]
	var dmg = Cards.Power[CardsEnum.get(cardt)]
	monsterhp -= dmg
	cardNodes.remove_at(0)
	
	pass # Replace with function body.
