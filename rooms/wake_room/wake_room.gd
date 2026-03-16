class_name WakeRoom
extends Room

var wake_room_state: WakeRoomState
var cur_code: String

@onready var right_code: String = "1245"
@onready var character := $Character

func get_state() -> WakeRoomState:
	return wake_room_state

func request_connections() -> void:
	wake_room_state.button_pressed.connect(_on_pressed)
	wake_room_state.button_unpressed.connect(_unpressed)

func _unpressed() -> void:
	cur_code.remove_char(wake_room_state.last_input)

func _on_pressed() -> void:
	cur_code += str(wake_room_state.last_input)
	var all_pressed := true
	for button: WallButtonState in wake_room_state.buttons:
		all_pressed = wake_room_state.button.pressed and all_pressed
	if all_pressed and cur_code == right_code:
		wake_room_state.door.unlock()
	else:
		cur_code = ""
