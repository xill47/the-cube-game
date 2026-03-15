class_name CubeHolderState
extends InteractableState

signal holder_opened()
signal cube_taken()

var locked := true
var cube_present := true

static func create(_safe: CubeHolder) -> CubeHolderState:
	var state := CubeHolderState.new()
	return state

func unlock_stand():
	#When puzzle is solved
	locked = false
	on_changed()
	holder_opened.emit()

func interact() -> void:
	if locked:
		#Look at first side of the Cube
		pass
	else:
		#Add Cube to the players inventory - Allow player to use Cube
		cube_taken.emit()
