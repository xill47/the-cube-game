class_name CubeContainer
extends SubViewportContainer

@onready var cube_3d: MeshInstance3D = %Cube3D
@onready var map: Node3D = %Map
@export var rotation_time: float
var rotatable: bool = true
var rotating: bool = false
var rotate_direction
var start_basis: Basis = Basis.IDENTITY
var target_basis: Basis



#Adding queue sounds like a good idea, but i donno
func _input(event: InputEvent) -> void:
	if event is InputEventKey and rotatable:
		if event.is_pressed():
			rotatable = false
			if event.keycode == KEY_Q:
				rotate_direction = Vector3( 0, 0, 1)
			elif event.keycode == KEY_E:
				rotate_direction = Vector3( 0, 0, -1)
			elif event.is_action("move_down"):
				rotate_direction = Vector3(-1, 0, 0)
			elif event.is_action("move_up"):
				rotate_direction = Vector3(1, 0, 0)
			elif event.is_action("move_right"):
				rotate_direction = Vector3(0, -1, 0)
			elif event.is_action("move_left"):
				rotate_direction = Vector3(0, 1, 0)
			target_basis = start_basis.rotated(rotate_direction, TAU / 4)
			await rotation_animation()
			rotatable = true

func rotation_animation() -> bool:
	rotating = true
	create_tween().tween_method(interpolate, 0.0, 1.0, rotation_time).set_trans(Tween.TRANS_EXPO)
	await get_tree().create_timer(rotation_time + 0.1).timeout
	rotating = false
	start_basis = cube_3d.basis
	print(start_basis)
	return true

func interpolate(weight):
	cube_3d.basis = start_basis.slerp(target_basis, weight).orthonormalized()
