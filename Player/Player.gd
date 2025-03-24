extends CharacterBody2D

#Common Variables
@export var HP : int
@export var SPEED : float
var reservedSPEED : float
var isDead = false

@export var JUMP_VELOCITY : float
var reservedJUMP_VELOCITY : float
@onready var anim = get_node("Anim")
var direction : Vector2= Vector2.ZERO

#Acceleraton & Friction
@export var acc : int
@export var friction : float
var reservedacc : int
var reservedfriction : int

# this variable detects if player is facing left or right.
var L_R = "right"

# Get the gravity from the project settings to be synced with RigidBody nodes.
@export var gravity : float
#Coyote Time
@export var coyote_time : float # Time allowed for jumping after leaving the ground
var coyote_timer : float  # Start the timer at zero
var is_on_ground = false
#Jump Buffer
@export var jump_buffer_time : float  #measures how close player is to the ground to be able to jump buffer
var jump_buffer_timer: float
var jumpBuffer = false

#Crouch var
var isCrouched = false
var forceCrouch = false

#Damaged var
var isDamaged = false
@export var knockBack : int
@export var knockBack_x : float
@onready var knockbacktimer = $knockback

#attack
@onready var Atkpreload = preload("res://Player/slash_attack.tscn")
@onready var Attck = Atkpreload.instantiate()

#Climb var / Raycast
@onready var RayCast_up : RayCast2D = $detect_up
@onready var RayCast_down : RayCast2D = $detect_down
var isClimbing = false
var detect_Up
var detect_Down

#Detect floor
var data
var TileCoords
var tileValue

#TileEffects
var Slippery : bool
var Slowed: bool





func _ready():
	#gives value to the reserved var
	reservedSPEED = SPEED
	reservedacc = acc
	reservedfriction = friction
	reservedJUMP_VELOCITY = JUMP_VELOCITY
	
	#Sets up the Spawn Position
	global_position = GlobalVar.spawnPos
	
	#Disables the crouch so the player is standing at the start.
	$Crouched.disabled = true
	$force_Crouch.monitoring = false
	
	#Attack
	Attck.spawnPosition = global_position
	add_child(Attck)


func _physics_process(delta):
	#print(velocity.x)
	
	
	
	#Initializes the raycast
	detect_Up = RayCast_up.get_collider()
	detect_Down = RayCast_down.get_collider()

	if HP > 0:
		#print(tileValue)
		#print(detect_Down)
		#print(RayCast_down.get_collider_rid())
		GlobalVar.currentPlayerPos = global_position
		#print(coyote_timer)
		#print("Slippery = " ,Slippery, ": friction = ", friction, ": Acc = ", acc, ": Speed = ", SPEED)
		#Seperates the climbing Movement and Normal Movement
		if isClimbing == false:
			Falling(delta)	
			
			tileDetector()
			onIce()
			onSlime() 
			animation()
			
			direction.x = Input.get_axis("Left", "Right")
			#moves the player when an input is pressed
			if direction.x:
				
				if direction.x > 0:
					velocity.x =  min(velocity.x+acc, SPEED)
				if direction.x < 0:
					velocity.x =  max(velocity.x-acc, -SPEED)
				#print(velocity.x)
				
			#Makes sure the player stops when the button is released
			else:
				velocity.x = move_toward(velocity.x, 0, friction)
	
			# Handle jump.
			if Input.is_action_just_pressed("Jump") && forceCrouch == false:
				if is_on_ground == true && (coyote_timer > 0):
					Jump()
				else:
					jumpBuffer = true
					get_tree().create_timer(jump_buffer_time).timeout.connect(jumpBuffTimeout)
					
			#Sets Crouch Status
			if (Input.is_action_pressed("Crouch") && is_on_floor()) or (forceCrouch == true && is_on_floor()):
				if detect_Down && tileValue == 2:
					isClimbing = true
					position.y = position.y + 3
				else:
					Crouch()
					isCrouched = true		
			elif Input.is_action_just_released("Crouch") or forceCrouch == false:
				isCrouched=false
				notCrouch()
			
			if Input.is_action_pressed("Climb") && (detect_Up):
				
				isClimbing = true
				
			
		#Seperates the climbing Movement and Normal Movement
		elif isClimbing == true:
			#knockbacktimer.stop()
			Slippery = false
			onIce()
			if direction == Vector2.ZERO:
				#print("Stopped")
				anim.pause()
			else:
				anim.play("Climb")
			direction = Input.get_vector("Left","Right","Climb","Crouch")
			#print(direction)
			velocity = direction * SPEED/1.8
			if Input.is_action_just_pressed("Jump"):
				isClimbing = false
				Jump()
			if !detect_Down && !detect_Up:
				isClimbing = false
			if detect_Up && is_on_floor():
				isClimbing = false
			
		
		move_and_slide()
		
			

	elif HP <= 0:
		Death()
		$Death.emitting = true
		await $Death.finished
		queue_free()


func Falling(delta):
	#fall logic
	if is_on_floor():  # Check if the character is on the ground
		coyote_timer = coyote_time  # Reset the timer when on the ground
		is_on_ground = true
		Slippery = false
		Slowed = false
		
		if jumpBuffer == true:
			Jump()
			#print("Jump Buffer works \n")
			jumpBuffer = false
			
	else:
		velocity.y += gravity * delta
		coyote_timer -= .01  # Start counting down when in the air
		if Input.is_action_just_released("Jump") && velocity.y < 0 or jumpBuffer == true && velocity.y < 0:
			velocity.y = JUMP_VELOCITY / 20
			

#Jump Functions	
func Jump():		
	velocity.y = JUMP_VELOCITY
	is_on_ground = false
func jumpBuffTimeout():
	jumpBuffer = false
	

#Crouch Functions
func Crouch():
	$Body.disabled = true
	$Crouched.disabled = false
	$force_Crouch.monitoring = true
	$Body.visible = false
	$HurtBox/NormalHbox.disabled = true
	$HurtBox/NormalHbox.visible = false
	
	$HurtBox/CrouchedHbox.disabled = false
	$HurtBox/CrouchedHbox.visible = true
	
func notCrouch():
	$Crouched.disabled = true
	$force_Crouch.monitoring = false
	$Body.disabled = false
	$Body.visible = true
	$HurtBox/CrouchedHbox.disabled = true
	$HurtBox/CrouchedHbox.visible = false
	$HurtBox/NormalHbox.disabled = false
	$HurtBox/NormalHbox.visible = true
	
#This func detects the tiles that the raycastdown touches and gets its custom data
func tileDetector():
	if detect_Down is TileMapLayer:
		TileCoords = detect_Down.get_coords_for_body_rid(RayCast_down.get_collider_rid())
		#print(RayCast_down.get_collider_rid())
		data = detect_Down.get_cell_tile_data(TileCoords)
			#print(data)
			#Make it detect the floor
		if data:
			tileValue = data.get_custom_data("Tile_value")
			#print(tileValue)
		else:
			return 
			

func onIce():
	
	if detect_Down && tileValue == 1:
		#print("Im on Ice")
		friction = 2
		acc = 5
		SPEED = 325
		JUMP_VELOCITY = reservedJUMP_VELOCITY
		Slippery = true
		

	if !Slippery: #&& is_on_ground:
		#print("not on Ice")
		await get_tree().create_timer(.07).timeout
		friction = reservedfriction
		acc = reservedacc
		SPEED = reservedSPEED
	if !Slippery && isClimbing:
		friction = reservedfriction
		acc = reservedacc
		SPEED = reservedSPEED

		
	
		
func onSlime():
	if detect_Down && tileValue == 3:
		SPEED = 70
		JUMP_VELOCITY = -190
		

	if !detect_Down && is_on_ground:
		SPEED = reservedSPEED
		JUMP_VELOCITY = reservedJUMP_VELOCITY
	

			
func animation():
	if isDamaged == false:
	#makes char face
	#Left
		if direction.x == -1:
			L_R = "left"
			anim.flip_h = true
		#Right
		elif direction.x == 1:
			L_R = "right"
			anim.flip_h = false
		
		#Running & Idle Animation
		if isCrouched == false && velocity.y == 0:
			if !Slippery:
				if direction.x == 0:
					anim.play("Idle")
				elif direction.x != 0:
					anim.play("Run")
			elif Slippery:
				if velocity.x != 0:
					anim.play("Slippery")
				elif velocity.x == 0:
					anim.play("Idle")
			
				
		#Jump & Falling Animation
		elif velocity.y < 0:
			anim.play("Jump")
		elif velocity.y > 0:
			anim.play("Fall")
		#Crouch
		if isCrouched == true && velocity.y == 0:
			if direction.x == 0:
				anim.play("Duck")
			elif direction.x != 0:
				anim.play("Duck_walk")
	
	
func _on_force_crouch_body_entered(body):
	forceCrouch = true


func _on_force_crouch_body_exited(body):
	forceCrouch = false


func _on_hurt_box_body_entered(body):
	$HurtBox.set_deferred("monitoring",false)
	
	SPEED = 0
	isClimbing = false
	velocity.y = knockBack
	#knockbacktimer.start()
	knockback_Func()
	
	anim.play("Hurt")
	HP-=1
	await anim.animation_finished		
	$HurtBox.set_deferred("monitoring",true)	
	
	#knockbacktimer.stop()
	
	SPEED = reservedSPEED
	
	
func knockback_Func():
	
	if L_R == "left":
		for n in range(15):
			await get_tree().create_timer(.01).timeout
			position.x += knockBack_x
			
	if  L_R == "right":
		for n in range(15):
			await get_tree().create_timer(.01).timeout
			position.x -= knockBack_x
			
		
#func _on_knockback_timeout():
	#if L_R == "left":
		#position.x += knockBack_x
		#SPEED = 0
	#if  L_R == "right":
		#position.x -= knockBack_x
		#SPEED = 0

func Death():
	GlobalVar.Score = 0
	isDead=true
	$Anim.hide()
	$Body.disabled = true
	$HurtBox.monitoring = false
	
	
