extends Control

func _on_pass_turn_pressed():
	StateMachine.next_state()
	pass # Replace with function body.

func _process(delta):
	$CanvasLayer/MonsterHealth.text = "MONSTER HEALTH: " + str(StateMachine.monsterhp)
	$CanvasLayer/PlayerHealth.text = "PLAYER HEALTH: " + str(StateMachine.playerhp)
