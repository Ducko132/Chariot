extends Control

func _on_pass_turn_pressed():
	StateMachine.next_state()
	pass # Replace with function body.

func _process(delta):
	$CanvasLayer/MonsterHealth.text = "MONSTER HEALTH: " + str(StateMachine.monsterhp) + " MONSTER DOES: " + str(StateMachine.curmonstermove)
	$CanvasLayer/PlayerHealth.text = "PLAYER HEALTH: " + str(StateMachine.playerhp) + " PLAYER MANA: " + str(StateMachine.playermana)
