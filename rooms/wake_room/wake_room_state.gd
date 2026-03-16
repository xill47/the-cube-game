class_name WakeRoomState
extends RoomState

var door: DoorState

@warning_ignore("shadowed_variable")
static func create(door: DoorState) -> WakeRoomState:
	var state := WakeRoomState.new()
	state.door = door
	return state

func _on_door_entered() -> void:
	request_transition.emit(door)
