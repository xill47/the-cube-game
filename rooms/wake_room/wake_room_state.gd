class_name WakeRoomState
extends RoomState

signal button_pressed()
signal button_unpressed()

var buttons: Array[WallButtonState] = []
var door: DoorState
var last_input: int

@warning_ignore("shadowed_variable")
static func create(button1: WallButtonState, button2: WallButtonState, button3: WallButtonState, button4: WallButtonState, door: DoorState) -> WakeRoomState:
	var state := WakeRoomState.new()
	state.buttons.push_back(button1)
	state.buttons.push_back(button2)
	state.buttons.push_back(button3)
	state.buttons.push_back(button4)
	state.door = door
	for button in state.buttons:
		button.on_pressed.connect(state._on_pressed)
		button.unpressed.connect(state._unpressed)
	door.door_entered.connect(state._on_door_entered)
	return state

func _unpressed(code_number):
	last_input = code_number
	button_unpressed.emit()

func _on_pressed(code_number):
	last_input = code_number
	button_pressed.emit()

func _on_door_entered() -> void:
	request_transition.emit(door)
