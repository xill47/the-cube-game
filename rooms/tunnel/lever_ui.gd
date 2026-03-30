extends Sprite2D

@export var changing: Array[Sprite2D]

@onready var state : bool = false

func change_state():
	state = not state
	if state:
		frame_coords.x = 1
	else:
		frame_coords.x = 0


func _on_area_2d_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if event.is_action_pressed("shoot"):
		change_state()
		if get_parent().is_solved():
			return
		for lever in changing:
			lever.change_state()
