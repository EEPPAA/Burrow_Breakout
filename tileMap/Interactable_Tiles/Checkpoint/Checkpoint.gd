extends Area2D

var Active: bool = false
@onready var anim = get_node("AnimatedSprite2D")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if !Active:
		anim.play("Empty")
	
	if GlobalVar.spawnPos != global_position:
		Active = false
		
	

func _on_body_entered(body):
	if !Active:
		GlobalVar.spawnPos = global_position
		print("Player position: ",GlobalVar.spawnPos)
		print("Checkpoint position: ", global_position)
		Active = true
		anim.play("Start")
		await anim.animation_finished
		anim.play("Idle")
		
		
		
	else:
		return
		
