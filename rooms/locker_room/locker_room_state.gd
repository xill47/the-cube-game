class_name LockerRoomState
extends RoomState

var plates: Array[PlateState] = []
var door: DoorState

@warning_ignore("shadowed_variable")
static func create(door: DoorState) -> LockerRoomState:
	var state := LockerRoomState.new()
	state.door = door
	door.door_entered.connect(state._on_door_entered)
	return state

func _on_door_entered() -> void:
	request_transition.emit(door)
