extends Node2D

var playerIn: bool
@onready var animSign = $ShopSignAnim

# Called when the node enters the scene tree for the first time.
func _ready():
	$AnimatedSprite2D.play("default")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	if playerIn:
		
		animSign.visible = true
		if Input.is_action_just_pressed("Climb"):
			get_tree().paused = true
			$Shop_Overlay.show()
			
			print("Balls")
	elif !playerIn:
		animSign.visible = false


func _on_area_2d_body_entered(body):
	playerIn = true
	animSign.play("default")


func _on_area_2d_body_exited(body):
	playerIn = false
	animSign.stop()
