extends CharacterBody2D

@export var speed : float
var movement : Vector2
var reservedMovement: Vector2
@export var gravity : float
@onready var anim : AnimatedSprite2D = $anim
@onready var Detect_Floor : RayCast2D = $RayCast2D
var ground_Ahead
@onready var ranMove : int = randi_range(0,1)

var isAlive : bool = true
@export var resPawnTimer:float
var looked: int
#Player pos
var Playerpos
var A2dPos
var Player

#Attack Variables
var Attack: bool = false
var canAttack : bool = true
@export var atkDelay: float


#FireBall
@onready var Fireball = preload("res://Enemy/Mob_2/mob_2_projectile.tscn")
#var instFireball

@export var Points: int


func _ready():
	
	if ranMove == 0:
		movement = Vector2.RIGHT
		Detect_Floor.position.x = Detect_Floor.position.x * (-1)
	elif ranMove == 1:
		movement = Vector2.LEFT
func _physics_process(delta):
	#print(movement)
	ground_Ahead = Detect_Floor.get_collider()
	
	Facing()
	move_and_slide()
	if is_on_floor():
		move()
		brain()
		DetectPosSwitch()
	else:
		fall(delta)
	if !isAlive && Player != null:
		if Player.isDead==true:
			#print("Working")
			#await get_tree().create_timer(resPawnTimer).timeout
			$".".set_collision_layer_value(4,true)
			movement = reservedMovement
			anim.visible = true
			Detect_Floor.enabled = true

			$Wall_Detect.set_deferred("monitoring",true)
			$HurtBox.set_deferred("monitoring",true)
			$Detect_Player.set_deferred("monitoring",true)

			
			canAttack = true
			isAlive = true

		
func move():
	velocity.x = speed * movement.x
	
func fall(delta):
	velocity.y += gravity * delta
	
func brain():
	if ground_Ahead == null:
		#print("no floor AHEAD!!")
		LoR()
func LoR():
	if movement == Vector2.LEFT:
		movement = Vector2.RIGHT
		reservedMovement = movement
	
	elif movement == Vector2.RIGHT:
		movement = Vector2.LEFT
		reservedMovement = movement
		anim.flip_h = false

func DetectPosSwitch():
	if movement == Vector2.LEFT:
		Detect_Floor.position.x = -10
	elif movement == Vector2.RIGHT:
		Detect_Floor.position.x = 10
		

	
		

	
func _on_wall_detect_body_entered(body):
	LoR()
	#print("wall detected")
	
func Facing():
	if movement != Vector2.ZERO && !Attack:
		anim.play("Walk")
		if movement == Vector2.RIGHT:
			anim.flip_h = true
		elif movement == Vector2.LEFT:
			anim.flip_h = false
	elif movement == Vector2.ZERO && !Attack:
		anim.play("Idle")


func _on_detect_player_body_entered(body):
	movement = Vector2.ZERO
	Playerpos = body.global_position.x
	A2dPos = $Detect_Player.global_position.x
	var instFireball = Fireball.instantiate()
	
	
	
	if Playerpos < A2dPos && canAttack:
		
		anim.flip_h = false
		
		instFireball.direction = Vector2.LEFT
		
		Attack = true
		if Attack && isAlive:
			anim.play("Attack")
			await anim.animation_finished
			#print("Finna fire")
			instFireball.global_position = $Marker2D.global_position
			get_parent().call_deferred("add_child",instFireball)
			movement = Vector2.LEFT
			reservedMovement = movement
			Attack = false
			
		
		Area2dBlink()
		
	elif Playerpos > A2dPos && canAttack:
		
		anim.flip_h = true
		
		instFireball.direction = Vector2.RIGHT
		
		Attack = true
	
		if Attack && isAlive:
			anim.play("Attack")
			await anim.animation_finished
			#print("Finna fire")
			instFireball.global_position = $Marker2D.global_position
			get_parent().call_deferred("add_child",instFireball)
			movement = Vector2.RIGHT
			reservedMovement = movement
			Attack = false
			
			
		
		
		Area2dBlink()


func Area2dBlink():
	$Detect_Player.set_collision_mask_value(1,false)
	await get_tree().create_timer(atkDelay).timeout
	$Detect_Player.set_collision_mask_value(1,true)	
	
	$Detect_Player.set_deferred("monitoring",false)
	await get_tree().create_timer(atkDelay).timeout
	$Detect_Player.set_deferred("monitoring",true)
		
func _on_hurt_box_body_entered(body):
	
	Player = body
	body.jumpBuffer = false
	body.Jump()
	Attack = false
	death()
		
func death():
	
	GlobalVar.Score += Points
	isAlive = false
	canAttack = false
	
	
	movement = Vector2.ZERO
	
	$Detect_Player.set_deferred("monitoring",false)
	$Wall_Detect.set_deferred("monitoring",false)
	$HurtBox.set_deferred("monitoring",false)
	
	$".".set_collision_layer_value(4,false)
	
	anim.visible = false
	Detect_Floor.enabled = false
	$Death.emitting = true
	#Score Animation
	$Score_Anim.text = str(Points)

	$Score_Anim.visible = true
	await get_tree().create_timer(1).timeout
	$Score_Anim.visible = false
	
	
			


func _on_visible_on_screen_notifier_2d_screen_exited():
	if isAlive:
		$anim.hide()
		


func _on_visible_on_screen_notifier_2d_screen_entered():
	if isAlive:
		$anim.show()
