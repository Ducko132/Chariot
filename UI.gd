extends Control

@onready var game_board = get_parent()
var firstturn = true
func _on_pass_turn_pressed():
	StateMachine.next_state()
	firstturn = false
	pass # Replace with function body.

func _ready():
	if firstturn: 
		$CanvasLayer/PassTurn.text = "Start the Game!"

func _process(delta):
	if !firstturn:
		$CanvasLayer/PassTurn.text = "Next Turn"
		
	$CanvasLayer/MonsterHealth.text = "MONSTER HEALTH: " + str(StateMachine.monsterhp) + "\nMONSTER DOES: " + str(StateMachine.curmonstermove)
	$CanvasLayer/PlayerHealth.text = "PLAYER HEALTH: " + str(StateMachine.playerhp) + "\nPLAYER MANA: " + str(StateMachine.playermana)
