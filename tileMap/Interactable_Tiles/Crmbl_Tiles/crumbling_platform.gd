extends StaticBody2D
@export var Breaktimer : float
@export var respawnTimer : float
@onready var anim = get_node("Shake")



func _on_area_2d_body_entered(body):
	if body.is_on_floor():
		AudioManager.Crmble.pitch_scale = (randf_range(0.8,1.1))
		AudioManager.Crmble.play()
		#print("is detecting")
		anim.play("Flash")
		$Crmble.emitting = true
		await get_tree().create_timer(Breaktimer).timeout
		disappear()
		await get_tree().create_timer(respawnTimer).timeout
		appear()
		
		
func disappear():
	$Shape.disabled = true
	$Area2D. monitoring = false
	anim.stop()
	$Crmble.emitting = false
	$Sprite2D.hide()
	
	
func appear():
	$Shape.disabled = false
	$Area2D. monitoring = true
	$Sprite2D.show()
	
