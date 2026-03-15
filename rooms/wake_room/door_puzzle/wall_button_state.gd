class_name WallButtonState
extends InteractableState

signal on_pressed()
signal unpressed()

var code_number: int
var pressed := false

static func create(button: WallButton) -> WallButtonState:
	var state := WallButtonState.new()
	state.code_number = button.code
	return state

func interact() -> void:
	if not pressed:
		on_pressed.emit(code_number,true)
	else:
		unpressed.emit(code_number,false)
