extends Control

func Time_Stop():
	$TEXT/Timer.stop()


func _on_main_menu_pressed():
	get_tree().paused = false
	get_tree().change_scene_to_file("res://Play_scene/start_screen.tscn")


func _on_next_level_pressed():
	get_tree().paused = false
	get_tree().change_scene_to_file("res://Play_scene/start_screen.tscn")
