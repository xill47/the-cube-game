class_name PlateState
extends State

var enabled: bool
var permanent: bool
var pressed: bool

static func create(plate: Plate) -> PlateState:
	var state := PlateState.new()
	state.enabled = plate.starts_enabled
	state.permanent = plate.permanent
	return state

func enable() -> void:
	enabled = true
	on_changed()

func step(character: CharacterState) -> void:
	if pressed and permanent:
		return
	pressed = character != null
	if pressed:
		print("Character on the plate")
	on_changed()
