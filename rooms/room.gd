class_name Room
extends Node2D

@export var character: Character
@export var plates: Array[Plate]
@export var interactables: Array[Interactable]
@export var enemies: Array[Enemy]

var state: RoomState

func _enter_tree() -> void:
	if state == null:
		state = RoomState.init_from_room(self)
