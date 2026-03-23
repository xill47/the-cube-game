class_name WallLeverState
extends InteractableState

var pressed := false

static func create(_lever: WallLever) -> WallLeverState:
	var state := WallLeverState.new()
	return state


func interact() -> void:
	if pressed:
		pressed = false
	else:
		pressed = true
	on_changed()
