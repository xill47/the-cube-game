class_name CubeControl
extends SubViewportContainer
const controls = ["W","S","A","D","Q","E","M"]
@export var rotation_time: float

var being_dragged: bool = false
var mouse_offset:Vector2
var visable: bool = true
var map_opened: bool = false
var rotatable: bool = true
var rotating: bool = false
var rotate_direction
var start_basis: Basis = Basis.IDENTITY
var target_basis: Basis
var last_position: Basis

@onready var cube_3d: MeshInstance3D = %Cube3D
@onready var map: Node3D = %Map

func _process(_delta: float) -> void:
	if being_dragged:
		follow_mouse()
		

func follow_mouse():
	position = get_global_mouse_position() - mouse_offset

#Adding queue, sounds like a good idea, but i donno
#TODO For some reason stops when out of target
func _input(event: InputEvent) -> void:
	if event is InputEventKey and rotatable:
		if event.is_pressed() and controls.has(event.as_text()):
			rotatable = false
			if event.is_action("rotate_ccw"):
				rotate_direction = Vector3( 0, 0, 1)
			elif event.is_action("rotate_cw"):
				rotate_direction = Vector3( 0, 0, -1)
			elif event.is_action("move_down"):
				rotate_direction = Vector3(-1, 0, 0)
			elif event.is_action("move_up"):
				rotate_direction = Vector3(1, 0, 0)
			elif event.is_action("move_right"):
				rotate_direction = Vector3(0, -1, 0)
			elif event.is_action("move_left"):
				rotate_direction = Vector3(0, 1, 0)
			
			if event.is_action("open_map"):
				if map_opened:
					target_basis = last_position
				else:
					target_basis = Basis.IDENTITY.rotated(Vector3.DOWN, TAU / 4)
				map_opened = not map_opened
			else:
				target_basis = start_basis.rotated(rotate_direction, TAU / 4)
				last_position = target_basis
			print(target_basis)
			await rotation_animation()
			rotatable = true

func rotation_animation() -> bool:
	rotating = true
	create_tween().tween_method(interpolate, 0.0, 1.0, rotation_time).set_trans(Tween.TRANS_EXPO)
	await get_tree().create_timer(rotation_time + 0.1).timeout
	rotating = false
	start_basis = cube_3d.basis
#	print(start_basis)
	return true

func interpolate(weight):
	cube_3d.basis = start_basis.slerp(target_basis, weight).orthonormalized()


func _on_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.is_pressed():
			mouse_offset = get_local_mouse_position()
			being_dragged = true
		if event.is_released():
			being_dragged = false
