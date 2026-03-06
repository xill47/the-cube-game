class_name WorldState
extends StateBase

signal request_transition(door: DoorState)

var character: CharacterState
var current_room: RoomState

static func create(room: Room) -> WorldState:
	var state := WorldState.new()
	state.character = CharacterState.init_from_character(room.character)
	state.move_to_room(room, room.character.position)
	return state

func move_to_room(room: Room, spawn: Vector2) -> void:
	if current_room != null:
		for door: DoorState in current_room.doors:
			door.request_transition.disconnect(_on_door_request_transition)

	character.position = spawn
	character.move_room()
	current_room = RoomState.init_from_room(room, character)
	room.state = current_room
	for door: DoorState in current_room.doors:
		door.request_transition.connect(_on_door_request_transition)
	
func _on_door_request_transition(door: DoorState) -> void:
	request_transition.emit(door)
