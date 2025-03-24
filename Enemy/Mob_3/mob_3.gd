extends CharacterBody2D

var isAlive:bool = true
@export var speed : float
var reservedSpeed: float
@export var resPawnTimer:float
var movement : Vector2
var reservedMovement : Vector2
@export var gravity : float
@onready var anim : AnimatedSprite2D = $AnimatedSprite2D
@onready var Detect_Floor : RayCast2D = $RayCast2D
var ground_Ahead
@onready var ranMove : int = randi_range(0,1)

#Chase
var playerPos:Vector2
var Chasing:bool = false

@export var Points: int


func _ready():
	reservedSpeed = speed
	anim.play("Walk")
	if ranMove == 0:
		movement = Vector2.RIGHT
		
	elif ranMove == 1:
		movement = Vector2.LEFT
		Detect_Floor.position.x = Detect_Floor.position.x * (-1)


func _physics_process(delta):
	#print(Detect_Floor.position.x)
	
	if isAlive:
		ground_Ahead = Detect_Floor.get_collider()
		#print(ground_Ahead)
		#print(speed)
		animation()
		Facing()
		move_and_slide()
		if is_on_floor():
			brain()
			move()
			
		else:
			fall(delta)
		if Chasing == false:
			speed = reservedSpeed
	elif !isAlive:
		movement = Vector2.ZERO
		animation()
		pass
	#print(speed)
	

func move():
	velocity.x = speed * movement.x
func fall(delta):
	velocity.y += gravity * delta
	
func brain():
	if ground_Ahead == null:
		LoR()
		
		
func LoR():
	if movement == Vector2.LEFT:
		movement = Vector2.RIGHT
		Detect_Floor.position.x = Detect_Floor.position.x * (-1)
			
	elif movement == Vector2.RIGHT:
		movement = Vector2.LEFT
		anim.flip_h = false
		Detect_Floor.position.x = Detect_Floor.position.x * (-1)
		
func chaseLoR():
	if playerPos < global_position && ground_Ahead != null:
		#print("LEFT")
		movement = Vector2.LEFT
	elif playerPos > global_position && ground_Ahead != null:
		#print("RIGHT")
		movement = Vector2.RIGHT	
	
		
func Facing():
	if movement == Vector2.RIGHT:
		anim.flip_h = false
		Detect_Floor.position.x = 11
		
	elif movement == Vector2.LEFT:
		anim.flip_h = true	
		Detect_Floor.position.x = -11

func animation():
	if Chasing && isAlive:
		anim.play("Run")
	elif !Chasing && isAlive:
		anim.play("Walk")
	#if !isAlive:
		
	
func _on_wall_detect_body_entered(body):
	LoR()


func _on_player_detect_body_entered(body):
	Chasing = true
	playerPos = body.global_position
	chaseLoR()
	if Chasing == true:
		for n in 210:
			
			speed += 1
			#print(speed)
			
			await get_tree().create_timer(.006).timeout
		
		
	
	#Facing()


func _on_player_detect_body_exited(body):
	#await get_tree().create_timer(.1).timeout
	
	Chasing = false
	


func _on_hurt_box_body_entered(body):
	#Death
	GlobalVar.Score += Points
	$Score_Anim.text = str(Points)
	body.jumpBuffer = false
	body.Jump()
	$".".set_collision_layer_value(4,false)
	reservedMovement=movement 
	isAlive = false
	anim.play("Dead")
	#print("Dead")
	
	$Player_Detect.set_deferred("monitoring",false)
	$Wall_Detect.set_deferred("monitoring",false)
	$HurtBox.set_deferred("monitoring",false)
	
	
	#Score Animation
	$Score_Anim.visible = true
	await anim.animation_finished
	$Score_Anim.visible = false
	
	await get_tree().create_timer(resPawnTimer).timeout
	
	#Revive
	anim.play("Revive")
	await anim.animation_finished
	$".".set_collision_layer_value(4,true)
	$Wall_Detect.set_deferred("monitoring",true)
	$HurtBox.set_deferred("monitoring",true)
	movement = reservedMovement
	brain()
	$Player_Detect.set_deferred("monitoring",true)
	speed = reservedSpeed
	isAlive = true

func _on_visible_on_screen_notifier_2d_screen_exited():
	$AnimatedSprite2D.visible = false
func _on_visible_on_screen_notifier_2d_screen_entered():
	$AnimatedSprite2D.visible = true
