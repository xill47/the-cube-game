class_name KeyMakerState
extends InteractableState

signal maker_opened()

var solved := false

static func create(_safe: KeyMaker) -> KeyMakerState:
	var state := KeyMakerState.new()
	return state

func solve():
	solved = true
	on_changed()

func interact() -> void:
	if not solved:
		maker_opened.emit()
