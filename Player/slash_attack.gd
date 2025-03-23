extends CharacterBody2D
@onready var anim = get_node("anim")
var mousePos
var spawnPosition : Vector2
var canAttack = true


func _ready():
	anim.visible = false
	$shape.disabled = true
	global_position = spawnPosition
func _physics_process(delta):
	mousePos = get_global_mouse_position()
	
	if Input.is_action_just_pressed("Attack") && canAttack == true:
		look_at(mousePos)
		anim.visible = true
		$shape.disabled = false
		canAttack = false
		anim.play("default")
		await anim.animation_finished
		$shape.disabled = true
		anim.visible = false
		canAttack = true
		
