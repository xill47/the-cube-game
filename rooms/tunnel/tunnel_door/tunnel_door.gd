class_name TunnelDoor
extends Interactable

@export var starts_locked: bool = false
@export var door_number: int

var state: TunnelDoorState

@onready var sprite := $Icon
@onready var collision := $Collision/CollisionShape2D
@onready var sound := $OpenCloseSound

func _ready() -> void:
	state.changed.connect(_on_state_changed)
	if state.locked:
		collision.set_deferred("disabled", false)
		sprite.frame_coords.x = 0
	else:
		collision.set_deferred("disabled", true)
		sprite.frame_coords.x = 1

func get_state() -> InteractableState:
	return state

func _on_state_changed():
	sound.play()
	if state.locked:
		collision.set_deferred("disabled", false)
		sprite.frame_coords.x = 0
	else:
		collision.set_deferred("disabled", true)
		sprite.frame_coords.x = 1
