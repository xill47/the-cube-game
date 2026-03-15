class_name WakeRoom
extends Room

var wake_room_state: WakeRoomState

@onready var right_code: String = "1245"

func get_state() -> WakeRoomState:
	return wake_room_state

#All buttons pressed in the right order - open the CubeStand
#If button unpressed - reset puzzle
