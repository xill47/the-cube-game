extends Node2D

var levers: Array

@export var level_lever: Area2D

func _ready() -> void:
	levers = get_children()

func is_solved() -> bool:
	var pressed: bool = true
	for lever in levers:
		if lever.state and pressed:
			pass
		else:
			pressed = false
	if pressed:
		level_lever.solved()
	return pressed
