class_name WallLever
extends Interactable

@export var door1 := Node2D
@export var door2 := Node2D
@export var door3 := Node2D

var state: WallLeverState

@onready var sprite = $Sprite

func _ready() -> void:
	state.changed.connect(_on_pressed)

func get_state() -> InteractableState:
	return state

func _on_pressed():
	door1.state.change_state()
	door2.state.change_state()
	door3.state.change_state()
	if state.pressed:
		sprite.frame_coords.x = 1
	else:
		sprite.frame_coords.x = 0
