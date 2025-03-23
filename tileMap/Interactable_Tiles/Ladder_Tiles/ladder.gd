extends Area2D




func _on_body_entered(body):
	body.canClimb = true


func _on_body_exited(body):
	body.canClimb = false
	body.isClimbing = false
