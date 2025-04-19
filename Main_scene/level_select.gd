extends Node2D





func _on_level_1_pressed():
	AudioManager.BGM_3.stop()
	GlobalVar.spawnPos = Vector2.ZERO
	get_tree().change_scene_to_file("res://Play_scene/level_1_scene.tscn")


func _on_level_2_pressed():
	AudioManager.BGM_3.stop()
	GlobalVar.spawnPos = Vector2.ZERO
	get_tree().change_scene_to_file("res://Play_scene/level_2_scene.tscn")


func _on_level_3_pressed():
	AudioManager.BGM_3.stop()
	GlobalVar.spawnPos = Vector2.ZERO
	get_tree().change_scene_to_file("res://Play_scene/level_3_scene.tscn")


func _on_level_4_pressed():
	AudioManager.BGM_3.stop()
	GlobalVar.spawnPos = Vector2.ZERO
	get_tree().change_scene_to_file("res://Play_scene/level_4_scene.tscn")


func _on_back_pressed():
	get_tree().change_scene_to_file("res://Play_scene/start_screen.tscn")
