class_name WakeRoom
extends Room

@export var buttons: Array[Node]

var wake_room_state: WakeRoomState
var cur_code: String

@onready var right_code: String = "1245"
@onready var character := $Character

func _ready() -> void:
	for button: WallButton in buttons:
		button.on_pressed.connect(_on_pressed)

func get_state() -> WakeRoomState:
	return wake_room_state

func _unpressed() -> void:
	cur_code.remove_char(wake_room_state.last_input)

func _on_pressed(code) -> void:
	cur_code += str(code)
	var all_pressed := true
	for button: WallButton in buttons:
		all_pressed = button.state.pressed and all_pressed
	if all_pressed and cur_code == right_code:
		wake_room_state.door.unlock()
	else:
		cur_code = ""
