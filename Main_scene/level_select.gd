extends Node2D





func _on_level_1_pressed():
	get_tree().change_scene_to_file("res://Play_scene/level_1_scene.tscn")


func _on_level_2_pressed():
	get_tree().change_scene_to_file("res://Play_scene/level_2_scene.tscn")


func _on_level_3_pressed():
	pass # Replace with function body.


func _on_level_4_pressed():
	pass # Replace with function body.


func _on_back_pressed():
	get_tree().change_scene_to_file("res://Play_scene/start_screen.tscn")
