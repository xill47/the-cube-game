class_name WallButtonState
extends InteractableState

var pressed := false

static func create(_button: WallButton) -> WallButtonState:
	var state := WallButtonState.new()
	return state


func unpress() -> void:
	pressed = false
	on_changed()


func interact() -> void:
	if pressed:
		return
	pressed = true
	on_changed()
