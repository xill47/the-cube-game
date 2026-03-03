class_name PlateState
extends RefCounted

signal changed

var enabled: bool
var pressed: bool

func enable() -> void:
	enabled = true
	changed.emit()

func step(character: CharacterState) -> void:
	pressed = character != null
	if pressed:
		print("Character on the plate")
	changed.emit()
