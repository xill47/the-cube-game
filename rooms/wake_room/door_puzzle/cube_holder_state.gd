class_name CubeHolderState
extends InteractableState

signal holder_opened()
signal cube_taken()

var locked := true
var cube_present := true

static func create(_safe: CubeHolder) -> CubeHolderState:
	var state := CubeHolderState.new()
	return state

func unlock():
	locked = false
	on_changed()
	holder_opened.emit()
	

func interact() -> void:
	if not locked:
		cube_taken.emit()
