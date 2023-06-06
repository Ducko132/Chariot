extends Control

func _on_play_pressed():
	StateMachine.start_game(1)
	self.queue_free()
	pass # Replace with function body.

func _on_mainmenu_pressed():
	get_tree().change_scene_to_file("res://main_menu.tscn")
	pass # Replace with function body.
