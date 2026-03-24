class_name SecurityRoomState
extends RoomState

var door: DoorState
var door2: DoorState

@warning_ignore("shadowed_variable")
static func create(door: DoorState, door2: DoorState) -> SecurityRoomState:
	var state := SecurityRoomState.new()
	state.door = door
	state.door2 = door2
	return state

func _on_door_entered() -> void:
	request_transition.emit(door)
