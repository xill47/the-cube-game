class_name WallButtonState
extends InteractableState

signal  pressed()

static func create(_button: WallButton) -> WallButtonState:
	var state := WallButtonState.new()
	return state

func interact() -> void:
	pressed.emit()
