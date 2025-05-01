extends Control

		

func _on_quit_pressed():
	get_tree().paused =  false
	AudioManager.BGM_1.stop()
	AudioManager.BGM_2.stop()
	AudioManager.BGM_3.stop()
	get_tree().change_scene_to_file("res://Play_scene/start_screen.tscn")
	

func _on_continue_pressed():
	get_tree().paused =  false
	$".".hide()
