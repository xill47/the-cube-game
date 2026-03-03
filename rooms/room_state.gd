class_name RoomState
extends RefCounted

signal changed

var character: CharacterState
var plates: Array[PlateState]

var solved: bool

func is_fully_solved() -> bool:
	return solved

func mark_solved() -> void:
	solved = true
	changed.emit()
