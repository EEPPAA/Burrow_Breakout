extends Node2D
@onready var Player = preload("res://Player/player.tscn")
@onready var Anim = $Ending/AnimationPlayer

func _ready():
	GlobalVar.Score = 0
	GlobalVar.Deathcount -= 1

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if !$Player_Slot.has_node("Player"):
		GlobalVar.Deathcount += 1
		print(GlobalVar.Deathcount)
		var Inst_player = Player.instantiate()
		$Player_Slot.add_child(Inst_player)


func _on_finish_body_entered(body):
	#$UI.hide()
	$Ending/Level_Finished.Time_Stop()
	get_tree().paused =  true
	$Ending.show()
	Anim.play("Fade")
	await Anim.animation_finished
	
	
	
