class_name CubeContainer
extends SubViewportContainer

@onready var cube_3d: MeshInstance3D = %Cube3D
var cur_cube_rotation: Vector3
@export var rotation_time: float
var rotatable: bool = true
var y_changed: bool

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventKey and rotatable:
		if event.keycode == KEY_Q:
			var rotate_direction
			if not y_changed:
				rotate_direction = Vector3( 0, 0, 90)
			else:
				rotate_direction = Vector3( 90, 0, 0)
			var tween = create_tween()
			tween.tween_property(cube_3d, "rotation_degrees", cur_cube_rotation + rotate_direction, rotation_time)
			await get_tree().create_timer(rotation_time + 0.1).timeout
			cur_cube_rotation = cube_3d.rotation_degrees
		if event.keycode == KEY_E:
			var rotate_direction
			if not y_changed:
				rotate_direction = Vector3( 0, 0, -90)
			else:
				rotate_direction = Vector3( -90, 0, 0)
			var tween = create_tween()
			tween.tween_property(cube_3d, "rotation_degrees", cur_cube_rotation + rotate_direction, rotation_time)
			await get_tree().create_timer(rotation_time + 0.1).timeout
			cur_cube_rotation = cube_3d.rotation_degrees
		if event.is_action_released:
			rotatable = false
			var input_direction = Input.get_vector("move_down", "move_up", "move_right", "move_left")
			var rotate_direction
			if not y_changed:
				rotate_direction = Vector3(input_direction.x, input_direction.y, 0)
			else:
				rotate_direction = Vector3(0 , input_direction.y, input_direction.x * -1)
			var tween = create_tween()
			tween.tween_property(cube_3d, "rotation_degrees", cur_cube_rotation + rotate_direction*90, rotation_time)
			await get_tree().create_timer(rotation_time + 0.1).timeout
			cur_cube_rotation = cube_3d.rotation_degrees
			if event.is_action("move_right") or event.is_action("move_left"):
				y_changed = not y_changed
			rotatable = true
