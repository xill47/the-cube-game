class_name WallButtonState
extends InteractableState

var pressed := false 

static func create(_button: WallButton) -> WallButtonState:
	var state := WallButtonState.new()
	return state

func interact() -> void:
	pressed = not pressed
