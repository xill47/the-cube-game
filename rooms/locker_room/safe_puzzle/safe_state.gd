class_name SafeState
extends InteractableState

signal safe_opened()

var locked := true

static func create(_safe: Safe) -> SafeState:
	var state := SafeState.new()
	return state

func unlock():
	locked = false
	on_changed()

func interact() -> void:
	if locked:
		safe_opened.emit()
