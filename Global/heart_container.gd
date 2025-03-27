extends HBoxContainer
@onready var Heart = preload("res://Global/heart.tscn")
@onready var player = $"../../Player_Slot/Player"
var InstHeart
var Heart_List : Array[Panel]
# Called when the node enters the scene tree for the first time.

func  _ready():
	for i in player.HP:
		InstHeart = Heart.instantiate()
		add_child(InstHeart)
	for n in $".".get_children():
		Heart_List.append(n)
		print(Heart_List)

func _process(delta):
	if player == null:
		player = $"../../Player_Slot/Player"
	if player != null:
		Update_hearts()
func Update_hearts():
	for i in range(Heart_List.size()):
		Heart_List[i].visible = i < player.HP
	

	
