class_name Door
extends Interactable

@export var starts_locked: bool = false
@export_file_path("*.tscn") var starting_leads_to: String
@export var leads_to_spawn: String

var unknown: bool = true
var state: DoorState

@onready var sprite := $Icon

func _ready() -> void:
	state.changed.connect(_on_state_changed)

func get_state() -> InteractableState:
	return state

func _on_state_changed():
	if state.locked:
		sprite.frame_coords.x = 1
	else:
		sprite.frame_coords.x = 2
