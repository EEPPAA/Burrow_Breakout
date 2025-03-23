extends CharacterBody2D



@export var speed : float
#@export var resPawnTimer:float
var movement : Vector2
var reservedMovement : Vector2
@export var gravity : float
@onready var anim : AnimatedSprite2D = $anim
@onready var Detect_Floor : RayCast2D = $RayCast2D
var ground_Ahead
@onready var ranMove : int = randi_range(0,1)

var isAlive:bool = true
var looked: int
var Respawn:bool=false
var Player

@export var Points: int


func _ready():
	anim.play("Walk")
	if ranMove == 0:
		movement = Vector2.RIGHT
		Detect_Floor.position.x = Detect_Floor.position.x * (-1)
	elif ranMove == 1:
		movement = Vector2.LEFT
func _physics_process(delta):
	ground_Ahead = Detect_Floor.get_collider()
	Facing()
	move_and_slide()
	
	if is_on_floor():
		move()
		brain()
		
	else:
		fall(delta)
	if !isAlive && Player != null:
		if Player.isDead==true:
			$".".set_collision_layer_value(4,true)
			#$".".set_collision_layer_value(2,true)
			movement = reservedMovement
			anim.visible = true
			$Wall_Detect.monitoring = true
			Detect_Floor.enabled = true
			$HurtBox.set_deferred("monitoring",true)
			$HurtBox/CollisionShape2D.set_deferred("disabled",false)
			#looked = 0
			Respawn = false
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
		
		Detect_Floor.position.x = Detect_Floor.position.x * (-1)
			
	elif movement == Vector2.RIGHT:
		movement = Vector2.LEFT
		anim.flip_h = false
		Detect_Floor.position.x = Detect_Floor.position.x * (-1)
		
func Facing():
	if movement == Vector2.RIGHT:
		anim.flip_h = true
		
	elif movement == Vector2.LEFT:
		anim.flip_h = false	
		
func _on_hurt_box_body_entered(body):
	body.jumpBuffer = false
	body.Jump()
	Player = body
	death()
		

func _on_wall_detect_body_entered(body):
	LoR()
	#print("wall detected")

		
func death():
	GlobalVar.Score += Points
	print(GlobalVar.Score)
	isAlive = false
	$".".set_collision_layer_value(4,false)
	#$".".set_collision_layer_value(2,false)
	reservedMovement = movement
	movement = Vector2.ZERO
	anim.visible = false
	$Wall_Detect.monitoring = false
	Detect_Floor.enabled = false
	$Death.emitting = true
	#$HurtBox.set_deferred("monitoring",false)
	$HurtBox/CollisionShape2D.set_deferred("disabled",true)
	
	#Score Animation
	$Score_Anim.text = str(Points)
	$Score_Anim.visible = true
	await get_tree().create_timer(1).timeout
	$Score_Anim.visible = false

	
