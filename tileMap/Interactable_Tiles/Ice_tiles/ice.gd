extends StaticBody2D




func _on_area_2d_body_entered(body):
	print("is detecting")
	body.friction = 1
	body.acc = 1


func _on_area_2d_body_exited(body):
	await get_tree().create_timer(1).timeout
	body.friction = body.reservedfriction
	body.acc = body.reservedacc
