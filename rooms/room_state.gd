@abstract
class_name RoomState
extends State

signal request_transition(door: DoorState)

var room_resource: PackedScene
var solved: bool

func enter_door(door: DoorState) -> void:
	request_transition.emit(door)
