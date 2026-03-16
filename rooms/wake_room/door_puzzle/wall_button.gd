class_name WallButton
extends Interactable

signal on_pressed()

@export var code: int

var state: WallButtonState
var pressed := false

@onready var sprite = $Sprite

func _ready() -> void:
	state.pressed.connect(_on_pressed)

func get_state() -> InteractableState:
	return state

func _on_pressed():
	if pressed:
		sprite.frame_coords.x = 0
		on_pressed.emit(code)
		pressed = false
	else:
		sprite.frame_coords.x = 1
		on_pressed.emit(code)
		pressed = true
