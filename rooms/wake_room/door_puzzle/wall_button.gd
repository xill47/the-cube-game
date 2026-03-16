class_name WallButton
extends Interactable

@export var code: int

var state: WallButtonState

@onready var sprite = $Sprite

func _ready() -> void:
	state.on_pressed.connect(_on_state_changed)
	state.unpressed.connect(_on_state_changed)

func get_state() -> InteractableState:
	return state

func _on_state_changed(_code_number, toggle):
	if toggle:
		sprite.frame_coords.x = 1
		state.pressed = true
	else:
		sprite.frame_coords.x = 0
		state.pressed = false
