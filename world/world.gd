class_name World
extends Node2D

@export var starting_room_scene: PackedScene

var current_room: Room

var state: WorldState
var character: CharacterState

func _on_state_provider_state_resolved() -> void:
	state.request_transition.connect(_on_request_transition)

func _ready() -> void:
	if state == null:
		current_room = starting_room_scene.instantiate()
		%WorldLayer.add_child(current_room) # would resolve state as well
		state.move_to_room(current_room.get_state(), character.position)
	else:
		# TODO Saving
		assert(false, "State should be null when world is first ready")

func _on_request_transition(door: DoorState) -> void:
	# TODO Add animation
	var next_room: Room = door.leads_to.instantiate()
	current_room.queue_free()
	%WorldLayer.add_child(next_room)
	state.move_to_room(next_room.get_state(), next_room.get_node(door.spawn_point).position)
	current_room = next_room
