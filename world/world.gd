class_name World
extends Node2D

@export var starting_room_scene: PackedScene

var state: WorldState
var current_room: Room

func _ready() -> void:
	if state == null:
		var room = starting_room_scene.instantiate() as Room
		current_room = room
		state = WorldState.create(room)
		%WorldLayer.add_child(room)
	else:
		# TODO Saving
		assert(false, "State should be null when world is first ready")
	state.request_transition.connect(_on_request_transition)

func _on_request_transition(door: DoorState) -> void:
	# TODO Add animation
	var next_room = door.leads_to.instantiate() as Room
	state.move_to_room(next_room, next_room.get_node(door.spawn_point).position)
	current_room.queue_free()
	current_room = next_room
	%WorldLayer.add_child(next_room)
