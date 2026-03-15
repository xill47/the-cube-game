class_name WorldState
extends State

signal request_transition(door: DoorState)

var character: CharacterState
var current_room: RoomState

@warning_ignore("shadowed_variable")
static func create(character: CharacterState) -> WorldState:
	var state := WorldState.new()
	state.character = character
	return state

func move_to_room(room: RoomState, spawn: Vector2) -> void:
	character.force_movement(spawn)
	character.move_room()
	current_room = room
	current_room.request_transition.connect(_on_room_request_transition)
func _on_room_request_transition(door: DoorState) -> void:
	request_transition.emit(door)
