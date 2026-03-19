class_name WallButton
extends Interactable

@export var code: int

var state: WallButtonState

@onready var sprite = $Sprite

func _ready() -> void:
	state.changed.connect(_on_pressed)

func get_state() -> InteractableState:
	return state

func _on_pressed():
	if state.pressed:
		sprite.frame_coords.x = 1
	else:
		sprite.frame_coords.x = 0
