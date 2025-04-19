extends CharacterBody2D

@export var speed :float
@onready var anim = $AnimatedSprite2D
var direction : Vector2 
@export var gravity : float
@export var JUMP_VELOCITY : float
var wallHit : bool
var bounce:int
@onready var rayCast : RayCast2D = $RayCast2D
var explosion = false
var explosive =  false
var playSFX : int = 0

var spawnPos : Vector2

#Detect floor
@onready var RayCast_down : RayCast2D = $RayCast2D
var detect_Down
var data
var TileCoords
var tileValue


func _ready():
	anim.play("default")
	
	

func _physics_process(delta):
	detect_Down = RayCast_down.get_collider()
	tileDetector()
	Phaser()
	velocity.x = speed * direction.x
	move_and_slide()
	
	if is_on_floor() && tileValue != 5:
		
		#print("on floor")
		velocity.y = JUMP_VELOCITY
		if bounce > 5:
			
			
			explode()
	elif !is_on_floor():
		
		velocity.y += gravity * delta
		
	if is_on_wall():
		
		explode()
	
	if bounce > 4 && is_on_ceiling():
		
		explode()
	
	
func Phaser():
	if tileValue == 5:
		global_position.y += 5
	


	
func explode():
	
	if playSFX == 0:
		playSFX += 1
		AudioManager.fire_bounce.pitch_scale = (randf_range(0.6,1))
		AudioManager.fire_bounce.play()	
		
	
		
	$Death.emitting = true
	$".".set_collision_layer_value(5,false)
	$AnimatedSprite2D.visible = false
	await $Death.finished
	queue_free()
func _on_area_2d_body_entered(body):
	if tileValue != 5:
		bounce += 1
		
	
			
	else: return

	
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
					
func _on_visible_on_screen_notifier_2d_screen_entered():
	$AnimatedSprite2D.show()
	


func _on_visible_on_screen_notifier_2d_screen_exited():
	$AnimatedSprite2D.hide()
	
