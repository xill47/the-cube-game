class_name TunnelLeverState
extends InteractableState

var pressed := false

static func create(_lever: TunnelLever) -> TunnelLeverState:
	var state := TunnelLeverState.new()
	return state


func interact() -> void:
	if pressed:
		pressed = false
	else:
		pressed = true
	on_changed()
