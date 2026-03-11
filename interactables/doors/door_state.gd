class_name DoorState
extends InteractableState

signal door_entered()

var locked: bool
var leads_to: PackedScene
var spawn_point: NodePath

static func create(door: Door) -> DoorState:
	var state := DoorState.new()
	state.locked = door.starts_locked
	state.leads_to = load(door.starting_leads_to)
	state.spawn_point = NodePath(door.leads_to_spawn)
	return state

func unlock():
	locked = false
	on_changed()

func interact() -> void:
	if not locked:
		door_entered.emit()
