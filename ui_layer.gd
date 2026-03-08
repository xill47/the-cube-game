class_name UILayer
extends CanvasLayer

var cube_on_screen: bool = false
var last_cube_position: Vector2
@onready var cube: CubeControl = %CubeControl 
@onready var cube_button: = %CubeButton 
func _ready() -> void:
	last_cube_position = cube.position

func _input(event: InputEvent) -> void:
	if event.is_pressed() and event.is_action("toggle_cube"):
		if cube_on_screen:
			last_cube_position = cube.position
			disappear_cube_animation()
		else:
			appear_cube_animation()
		cube_on_screen = not cube_on_screen

func appear_cube_animation():
	var tween = create_tween()
	tween.tween_property(cube,"position",last_cube_position, 0.25)
	tween.parallel()
	tween.tween_property(cube,"scale",Vector2(1,1), 0.25)

func disappear_cube_animation():
	var tween = create_tween()
	tween.tween_property(cube,"position",cube_button.position, 0.25)
	tween.parallel()
	tween.tween_property(cube,"scale",Vector2(0.5,0.5), 0.25)
