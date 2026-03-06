class_name RoomState
extends StateBase

var room_resource: PackedScene

var character: CharacterState
var plates: Array[PlateState]
var interactables: Array[InteractableState]
var doors: Array[DoorState]
var enemies: Array[EnemyState]

var solved: bool

static func init_from_node(_n: Node) -> StateBase:
	return init_from_room(_n as Room)

static func init_from_room(room: Room, character_state: CharacterState = null) -> RoomState:
	var state := RoomState.new()
	state.character = character_state
	if state.character == null:
		state.character = CharacterState.init_from_character(room.character)
	room.character.state = state.character

	state.plates = []
	for plate in room.plates:
		plate.state = PlateState.init_from_plate(plate)
		state.plates.push_back(plate.state)

	state.interactables = []
	state.doors = []
	for interactable in room.interactables:
		if interactable is Door:
			interactable.state = DoorState.init_from_door(interactable)
			state.interactables.push_back(interactable.state)
			state.doors.push_back(interactable.state)
	
	state.enemies = []
	for enemy: Enemy in room.enemies:
		enemy.state = EnemyState.init_from_enemy(enemy, state.character)
		state.enemies.push_back(enemy.state)

	state.room_resource = load(room.scene_file_path)
	return state

func is_fully_solved() -> bool:
	return solved

func mark_solved() -> void:
	solved = true
	on_changed()
