extends Node2D
@onready var Player = preload("res://Player/player.tscn")


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if !$Player_Slot.has_node("Player"):
		var Inst_player = Player.instantiate()
		$Player_Slot.add_child(Inst_player)
