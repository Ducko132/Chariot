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

func _on_mouse_entered(sprite):
	sprite.scale = Vector2(0.7,0.7)
	print("Hover")

func _on_mouse_exited():
	print("Mouse left")

func _input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton and event.pressed:
		print("click")

func _ready():
	for i in 8:
		for Card in CardsEnum:
			deck.append(Card)
	
	print(deck)
	print("we're starting")
	
	for i in 5:
		hand.append(deck[0])
		deck.remove_at(0)
	
	print("hand",hand)
	print(hand[6])
	var testcard = hand[6]
	# WOOOOO I FIGURED IT OUT
	print(Cards.Power[CardsEnum.get(testcard)])
	#load(Cards.Art[CardsEnum.get(hand[6])])
	#print(ctext)
	#add_child(cardex)
	
	
	for i in 3:
		var sprite = Sprite2D.new()
		var texture = load(Cards.Art[CardsEnum.get(hand[5])])
		sprite.texture = texture
		sprite.scale = Vector2(0.5,0.5)
		
		var area = Area2D.new()
		var shape = CollisionShape2D.new()
		shape.shape = RectangleShape2D.new()
		shape.shape.extents = sprite.texture.get_size() / 2*sprite.scale
		#sprite.set_process_input(true)
		
		#func _input(event):
		#	if event is InputEventMouseMotion:
		#		if sprite.get_rect().has_point(event.position):
		#			print("hover")
		
		sprite.add_child(area)
		area.add_child(shape)
		add_child(sprite)
		cardNodes.append(sprite)
		sprite.position = Vector2((i*400)+175,500)
		
		area.input_event.connect(_input_event)
		area.mouse_entered.connect(_on_mouse_entered(sprite))
		area.mouse_exited.connect(_on_mouse_exited, [sprite])

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
