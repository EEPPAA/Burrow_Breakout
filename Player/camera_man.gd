extends CharacterBody2D


const SPEED : float =10
var range : float = 10
var playerPos:Vector2
var direction:Vector2

func _ready():
	position = GlobalVar.spawnPos
	$Sprite2D.visible=false
func _process(delta):
	
	if $"..".has_node("Player"):
		playerPos = $"../Player".position
		position = playerPos
		
		
	else:
		position = GlobalVar.spawnPos
		
		
