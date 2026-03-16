class_name CubeHolderState
extends InteractableState

signal show_cube_requested(on_hide: Callable)
signal on_cube_hidden()

var locked := true
var cube_present := true

var character: CharacterState

@warning_ignore("shadowed_variable")
static func create(character: CharacterState) -> CubeHolderState:
	var state := CubeHolderState.new()
	state.character = character
	return state

func unlock_stand():
	locked = false
	on_changed()

func interact() -> void:
	if locked:
		show_cube_requested.emit(on_cube_hidden.emit)
		await on_cube_hidden
	else:
		cube_present = false
		character.take_cube()
		on_changed()
