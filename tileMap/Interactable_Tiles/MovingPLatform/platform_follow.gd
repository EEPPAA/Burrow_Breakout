extends PathFollow2D

var speed :float = 0.09
var end :bool = false
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	#progress_ratio += delta * speed
	#print(progress_ratio)
	if progress_ratio == 1:
		end = true
	elif progress_ratio == 0:
		end = false
	if !end:
		progress_ratio += delta * speed
	elif end:
		progress_ratio -= delta * speed
	


func _on_area_2d_body_entered(body):
	
	print("Detecting PLayer")


func _on_visible_on_screen_notifier_2d_screen_entered():
	$"../AnimatableBody2D".show()
	print("shown")


func _on_visible_on_screen_notifier_2d_screen_exited():
	$"../AnimatableBody2D".hide()
	print("Hidden")
