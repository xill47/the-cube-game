class_name CubeControl
extends SubViewportContainer

@export var rotation_time: float

var cube_controls := ["move_up","move_down","move_left","move_right",
	"rotate_ccw","rotate_cw",
	"open_map", "toggle_cube"]
var being_dragged: bool = false
var mouse_offset:Vector2
var on_screen: bool = true
var map_opened: bool = false
var rotatable: bool = true
var rotating: bool = false
var rotate_direction: Vector3
var start_basis: Basis = Basis.IDENTITY
var target_basis: Basis
var last_position: Basis

var character: CharacterState
var cube_stand: CubeHolderState

# null or Callable
var _on_next_hide: Variant = null

@onready var cube_3d: MeshInstance3D = %Cube3D
@onready var map: Node3D = %Map
@onready var sudoku_tiles: Array[Node] = %Sudoku.get_children()

func _ready() -> void:
	if cube_stand != null:
		cube_stand.show_cube_requested.connect(_on_show_cube_request)


func _on_show_cube_request(on_next_hide: Callable) -> void:
	_on_next_hide = on_next_hide
	# TODO call something that shows the cube
	visible = true
	_toggle_map()


func _process(_delta: float) -> void:
	if being_dragged:
		_follow_mouse()


func _follow_mouse():
	position = get_global_mouse_position() - mouse_offset


func _input(event: InputEvent) -> void:
	if event is InputEventKey and rotatable and on_screen:
		if event.is_pressed() and _event_check(event):
			rotatable = false
			if event.is_action("open_map") and (character.can_use_cube or visible):
				_toggle_map()
				return
			if not visible:
				rotatable = true
				return
			get_viewport().set_input_as_handled()
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
			target_basis = start_basis.rotated(rotate_direction, TAU / 4)
			last_position = target_basis
			await _rotation_animation()
			rotatable = true

func _event_check(event: InputEvent) -> bool:
	for known_event in cube_controls:
		if event.is_action(known_event):
			return true
	return false

func _toggle_map():
	if map_opened:
		target_basis = last_position
	else:
		target_basis = Basis.IDENTITY.rotated(Vector3.DOWN, TAU / 4)
	map_opened = not map_opened
	visible = true
	await _rotation_animation()
	if not map_opened:
		visible = false
		# TODO Move to "when cube is hidden, after hide animation finished"
		if _on_next_hide != null:
			_on_next_hide.call()
			_on_next_hide = null
	rotatable = true

func _rotation_animation() -> bool:
	rotating = true
	create_tween().tween_method(_interpolate, 0.0, 1.0, rotation_time).set_trans(Tween.TRANS_EXPO)
	await get_tree().create_timer(rotation_time + 0.1).timeout
	cube_3d.basis.x = snapped(cube_3d.basis.x, Vector3(1, 1, 1))
	cube_3d.basis.y = snapped(cube_3d.basis.y, Vector3(1, 1, 1))
	cube_3d.basis.z = snapped(cube_3d.basis.z, Vector3(1, 1, 1))
	rotating = false
	_sudoku_rotate()
	start_basis = cube_3d.basis
	return true

func _interpolate(weight: float):
	cube_3d.basis = start_basis.slerp(target_basis, weight).orthonormalized()

func _on_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.is_pressed():
			mouse_offset = get_local_mouse_position()
			being_dragged = true
		if event.is_released():
			being_dragged = false

func _sudoku_rotate():
	for tile in sudoku_tiles:
		tile.sudoku_opened(cube_3d)
