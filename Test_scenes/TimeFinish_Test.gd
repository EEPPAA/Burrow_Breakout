extends Control
@export var next_LVL : String

func Time_Stop():
	$TEXT/Timer.stop()


func _on_main_menu_pressed():
	get_tree().paused = false
	get_tree().change_scene_to_file("res://Play_scene/start_screen.tscn")


func _on_next_level_pressed():
	GlobalVar.spawnPos = Vector2.ZERO
	get_tree().paused = false
	get_tree().change_scene_to_file(next_LVL)
