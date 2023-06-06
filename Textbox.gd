extends CanvasLayer

# Big thanks to max for helping me figure out how to get the textbox to work!
@onready var textbox_container = $TextboxContainer
@onready var label = $TextboxContainer/MarginContainer/HBoxContainer/Label

enum State {READY,READING,DONE}

var curstate = State.READY
var text_queue = []

func _ready():
	hide_textbox()
	queue_text("Welcome to Helios! This is the tutorial level. Press enter to go to the next message!")
	queue_text("If you look at the bottom of your screen, you can see your hand. It consists of 3 cards.")
	queue_text("Each card has a cost, which is shown in the top right of the card, and an effect written on the card.")
	queue_text("Your health and mana, which is used to play cards, can be seen in the bottom left.")
	queue_text("The monster's health and move can be seen on the top left ish of the screen.")
	queue_text("Each turn, you'll get one mana added to your mana pool. This pool doesn't delete every turn, and is additive.\nFor example, turn one you'll get +1 mana, and turn two you'll get +2 mana.")
	queue_text("Spend this mana on cards. After you play your cards, press the next turn button, which will trigger the monster's phase")
	queue_text("The monster will then attack you or heal, based on it's health (the lower health, the more powerful the attacks)")
	queue_text("Your goal is to try to beat the monster. If you do, then you will be presented with 3 cards to add to your deck, of which you can choose 2")
	queue_text("Try to beat the final boss! If you hit 0 health, you lose!")

func _process(delta):
	if curstate == State.READY:
		if len(text_queue) != 0:
			display_text()
	elif curstate == State.READING:
		if Input.is_action_just_pressed("ui_accept"):
			label.visible_ratio = 1.0
			curstate = State.DONE
	else:
		if Input.is_action_just_pressed("ui_accept"):
			curstate = State.READY
			hide_textbox()

func queue_text(next_text):
	text_queue.push_back(next_text)

func hide_textbox():
	label.text = ""
	textbox_container.hide()

func show_textbox():
	textbox_container.show()

func display_text():
	var next_text = text_queue.pop_front()
	label.text = next_text
	label.visible_ratio = 0
	curstate = State.READING
	show_textbox()
	var tweener = create_tween()
	tweener.tween_property(label, "visible_ratio", 1, 3)
