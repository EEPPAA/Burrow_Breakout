extends Control

		

func _on_quit_pressed():
	get_tree().paused =  false
	get_tree().change_scene_to_file("res://Play_scene/start_screen.tscn")
	

func _on_continue_pressed():
	get_tree().paused =  false
	$".".hide()
