class_name Corridor
extends Room

var corridor_state: CorridorState
var solved := false

@onready var char := %Character

func get_state() -> CorridorState:
	return corridor_state


func _on_enter_area_body_entered(body: Node2D) -> void:
	if body == char and not solved:
		%MiniDoor.state.lock()
		%MiniDoor2.state.lock()
