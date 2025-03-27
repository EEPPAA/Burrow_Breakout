extends PathFollow2D
#0.09

@onready var SP = $"..".speed
var speed :float 

var end :bool = false
# Called when the node enters the scene tree for the first time.
func _ready():
	speed = 0
	await get_tree().create_timer(1).timeout
	speed = SP


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	
	#progress_ratio += delta * speed
	
	if progress_ratio == 1 && end == false:
		end = true
		speed = 0
		await get_tree().create_timer(1).timeout
		speed = SP
		
	elif progress_ratio == 0 && end == true:
		end = false
		speed = 0
		await get_tree().create_timer(1).timeout
		speed = SP
		
	if !end:
		progress_ratio += speed * delta
	elif end:
		progress_ratio -= speed * delta
	


func _on_area_2d_body_entered(body):
	
	print("Detecting PLayer")


func _on_visible_on_screen_notifier_2d_screen_entered():
	$"../AnimatableBody2D".show()
	print("shown")


func _on_visible_on_screen_notifier_2d_screen_exited():
	$"../AnimatableBody2D".hide()
	print("Hidden")
