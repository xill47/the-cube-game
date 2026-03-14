extends Room

var locker_room_state: LockerRoomState

@onready var character := $Character

func get_state() -> LockerRoomState:
	return locker_room_state
