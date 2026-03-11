class_name UILayer
extends CanvasLayer

var last_cube_position: Vector2

@onready var cube: CubeControl = %CubeControl
@onready var cube_button: = %CubeButton

func _ready() -> void:
	last_cube_position = cube.position

func _input(event: InputEvent) -> void:
	if event.is_pressed():
		if event.is_action("toggle_cube"):
			if cube.on_screen:
				last_cube_position = cube.position
				_disappear_cube_animation()
			else:
				_appear_cube_animation()
			cube.on_screen = not cube.on_screen
		if event.is_action("open_map"):
			if not cube.on_screen:
				cube.toggle_map()
				_appear_cube_animation()
				cube.on_screen = not cube.on_screen

func _appear_cube_animation():
	var tween = create_tween()
	tween.tween_property(cube,"position",last_cube_position, 0.25)
	tween.parallel()
	tween.tween_property(cube,"scale",Vector2(1,1), 0.25)

func _disappear_cube_animation():
	var tween = create_tween()
	tween.tween_property(cube,"position",cube_button.position, 0.25)
	tween.parallel()
	tween.tween_property(cube,"scale",Vector2(0.5,0.5), 0.25)
