extends Node2D
@onready var Player = preload("res://Player/player.tscn")
@onready var Anim = $Ending/AnimationPlayer

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if !$Player_Slot.has_node("Player"):
		var Inst_player = Player.instantiate()
		$Player_Slot.add_child(Inst_player)


func _on_finish_body_entered(body):
	$Ending/Level_Finished.Time_Stop()
	$UI.hide()
	$Ending.show()
	Anim.play("Fade")
	await Anim.animation_finished
	
	
	
