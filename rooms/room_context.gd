class_name RoomContext
extends Node

var room: RoomState

func _ready() -> void:
	# Add loading/deloading
	room = RoomState.new()
