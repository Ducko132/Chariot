extends Node2D
var Cards = preload("res://card.gd")
var CardsEnum = Cards.Cards
var Power = Cards.Power

enum State {BEGIN, DEAL, PLAYER1_DRAW, PLAYER1_PLAY, MONSTERTURN, END}
var curstate = State.BEGIN
var state_time = 0.0
var cardNodes = []

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
	
	for i in 3:
		var c = load("res://cardexample.tscn").instantiate()
		add_child(c)
		cardNodes.append(c)
		c.position = Vector2((i*200)+400,400)
		c.find_child("Label").text = "value:" + str(hand[i])

func _process(delta):
	for i in 3:
		cardNodes[i].find_child("Label").text = "value:" + str(hand[i])

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
	hand[2] = 5
	pass # Replace with function body.
