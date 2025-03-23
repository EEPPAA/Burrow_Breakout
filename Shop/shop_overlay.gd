extends CanvasLayer


# Called when the node enters the scene tree for the first time.
func _ready():
	$SubViewport/AnimatedSprite2D.play("default")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	#position = GlobalVar.currentPlayerPos


func _on_button_pressed():
	get_tree().paused = false
	$".".hide()
