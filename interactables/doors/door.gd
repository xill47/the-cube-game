class_name Door
extends Interactable

@export var starts_locked: bool = false
@export_file_path("*.tscn") var starting_leads_to: String
@export var leads_to_spawn: String

func _ready() -> void:
	if state == null:
		state = DoorState.init_from_door(self)
