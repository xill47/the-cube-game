class_name LockerRoomPuzzle
extends Node2D

@export var code: Array[int]

var solved: bool = false
var cur_input: int = 0
var rotating: bool
var mouse_offset: Vector2
var cur_number: int
var max_number: int
var cur_code: Array

@onready var animation_player: AnimationPlayer = $SafeAnimation
@onready var area_zero: Area2D = $SafeBack/Back/Area0
@onready var knob = %Knob

#There should be mouse_offset, but i am too stupid
func _process(_delta: float) -> void:
	if rotating and not solved:
		var angle = knob.get_angle_to(knob.get_global_mouse_position()) + (TAU / 4)
		knob.rotate(angle)

func _on_area_2d_input_event(_viewport: Node, event: InputEvent, _shape_idx: int):
	if event.is_action("shoot"):
		if event.is_pressed():
			$TurningSound.play()
			rotating = true
		if event.is_released():
			$TurningSound.stop()
			rotating = false

func _on_grab_area_mouse_exited() -> void:
	rotating = false

func on_dial_reset() -> void:
	cur_input += 1
	var code_to_text : String
	print("cur_input"+ str(cur_input))
	cur_code.push_back(max_number)
	for number in cur_code:
		code_to_text += str(abs(number))
	$Label.text = code_to_text
	if cur_input == 1 or cur_input == 3:
		max_number = -7
	elif cur_input == 2:
		max_number = 0
	elif cur_input == 4:
		if cur_code == code:
			puzzle_solved()
		else:
			dial_reset()

func puzzle_solved():
	animation_player.play("safe_opening")
	$OpeningSound.play()
	solved = true
	$Label.text = "Done"

func dial_reset():
	$ErrorResetSound.play()
	$Label.text = "Wrong"
	rotating = false
	cur_code.clear()
	max_number = 0
	cur_input = 0
	cur_number = 0
	knob.rotation = 0

func _on_area_entered(_area: Area2D, _source, extra_arg_0: int) -> void:
	$NumberClickSound.play()
	if cur_input == 0 or cur_input == 2:
		cur_number = extra_arg_0
		if cur_number > max_number:
			max_number = cur_number
	elif cur_input == 1 or cur_input == 3:
		cur_number = - extra_arg_0
		print(cur_number)
		if cur_number > max_number:
			max_number = cur_number


func _on_pointer_area_area_entered(area: Area2D) -> void:
	if area == area_zero and max_number != 0 and -7:
		$NumberClickSound.play()
		on_dial_reset()
