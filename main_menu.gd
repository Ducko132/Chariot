extends Control

func _on_play_pressed():
	#get_tree().change_scene_to_file("res://game_board.tscn")
	# make start_game take a number or string (like if it says tutorial, instantiate a tutorial. if it says
	# gameboard1 or 2, u can do like levels 1 or 2 etc.
	StateMachine.start_game()
	self.queue_free()
	pass # Replace with function body.

func _on_tutorial_pressed():
	get_tree().change_scene_to_file("res://tutorial.tscn")
	pass # Replace with function body.
