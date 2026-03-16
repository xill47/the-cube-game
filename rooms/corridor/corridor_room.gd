class_name Corridor
extends Room

var corridor_state: CorridorState

@onready var right_code: String = "1245"

func get_state() -> CorridorState:
	return corridor_state

#All buttons pressed in the right order - open the CubeStand
#If button unpressed - reset puzzle
