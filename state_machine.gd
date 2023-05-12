extends Node2D

enum State {BEGIN, DEAL, PLAYER1_DRAW, PLAYER1_PLAY, MONSTERTURN, END}
var curstate = State.BEGIN
var state_time = 0.0

# node to represent card (make copies manually)

var deck = []
var hand = [1,2,3]

func _ready():
	print("we're starting")
	var c = load("res://cardexample.tscn").instantiate()
	add_child(c)
	pass

func _process(delta):
	
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
