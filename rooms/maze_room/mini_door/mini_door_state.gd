class_name MiniDoorState
extends InteractableState

var locked: bool
var door_number: int

static func create(door: MiniDoor) -> MiniDoorState:
	var state := MiniDoorState.new()
	state.locked = door.starts_locked
	state.door_number = door.door_number
	return state

func change_state():
	locked = not locked
	on_changed()

func unlock():
	locked = false
	on_changed()

func lock():
	locked = true
	on_changed()

func interact() -> void:
	pass
