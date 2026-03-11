class_name TestChamberState
extends RoomState

var plates: Array[PlateState] = []
var door: DoorState

@warning_ignore("shadowed_variable")
static func create(plate1: PlateState, plate2: PlateState, door: DoorState) -> TestChamberState:
	var state := TestChamberState.new()
	state.plates.push_back(plate1)
	state.plates.push_back(plate2)
	state.door = door
	for plate in state.plates:
		plate.changed.connect(state._on_plate_changed)
	door.door_entered.connect(state._on_door_entered)
	return state

func _on_plate_changed() -> void:
	var all_pressed := true
	for plate: PlateState in plates:
		all_pressed = plate.pressed and all_pressed
	if all_pressed:
		door.unlock()

func _on_door_entered() -> void:
	request_transition.emit(door)
