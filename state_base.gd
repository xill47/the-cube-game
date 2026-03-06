class_name StateBase
extends RefCounted

signal changed

func on_changed() -> void:
	changed.emit()
