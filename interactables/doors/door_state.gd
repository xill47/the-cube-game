class_name DoorState
extends InteractableState

signal request_transition(door: DoorState)

var locked: bool
var leads_to: PackedScene
var spawn_point: NodePath

static func init_from_door(door: Door) -> DoorState:
	var state = DoorState.new()
	state.locked = door.starts_locked
	state.leads_to = load(door.starting_leads_to)
	state.spawn_point = NodePath(door.leads_to_spawn)
	return state

func unlock():
	locked = false
	on_changed()

func interact() -> void:
	if not locked:
		request_transition.emit(self)
