class_name WallButton
extends Interactable

@export var code: int

var state: WallButtonState

@onready var sprite = $Sprite

func get_state() -> InteractableState:
	return state

func _on_pressed():
	if state.pressed:
		#Unpressed state of the button
		sprite.frame_coords.x = 0
	else:
		#Pressed state of the button
		sprite.frame_coords.x = 1
