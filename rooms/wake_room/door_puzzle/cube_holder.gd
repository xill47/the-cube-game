class_name CubeHolder
extends Interactable

var state: CubeHolderState

@onready var sprite := $Sprite


func _ready() -> void:
	state.changed.connect(_on_state_changed)


func get_state() -> InteractableState:
	return state


func _on_state_changed():
	if state.locked:
		sprite.frame_coords.x = 1
	if not state.cube_present:
		sprite.frame_coords.x = 2
