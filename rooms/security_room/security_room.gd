class_name SecurityRoom
extends Room

var security_state: SecurityRoomState

func get_state() -> SecurityRoomState:
	return security_state
