extends Sprite2D

@export var code_sprites: Array[AnimatedSprite2D]
@export var correct_code : Array[int]
@export var operation_array: Array[int]

var cur_code: Array[int] = [1, 1, 1, 1]
var rotation_order: Array[String]
var cur_step: int
var execution_steps: int
var can_press_buttons: bool = true
var ejectable: bool = false

@onready var code_box := %CodeInput
@onready var key_sprite := $Base

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("pause"):
		get_parent().hide()

func _calculation():
	var cur_index: int = 0
	for number: int in cur_code:
		var changed_number = cur_code.get(cur_index) + operation_array.get(cur_index)
		if changed_number <= 0:
			changed_number = 0
		elif changed_number >= 5:
			changed_number = 5
		code_sprites.get(cur_index).frame = changed_number
		cur_code.set(cur_index, changed_number)
		cur_index += 1

func _rotation(direction):
	if direction == "right":
		var change = operation_array.pop_front()
		operation_array.push_back(change)
	else:
		var change = operation_array.pop_back()
		operation_array.push_front(change)


func _on_left_rotate_button_pressed() -> void:
	if ejectable:
		_on_reset_button_pressed()
	if not can_press_buttons:
		return
	if cur_step >= 5:
		return
	var label = code_box.get_child(cur_step)
	label.show()
	label.flip_h = true
	rotation_order.push_back("left")
	cur_step += 1

func _on_right_rotate_button_pressed() -> void:
	if ejectable:
		_on_reset_button_pressed()
	if not can_press_buttons:
		return
	if cur_step >= 5:
		return
	var label: TextureRect = code_box.get_child(cur_step)
	label.show()
	label.flip_h = false
	rotation_order.push_back("right")
	cur_step += 1

func _start_solving():
	can_press_buttons = false
	for step in rotation_order:
		await _rotation_animation(step)
		_rotation(step)
		_calculation()
		await  get_tree().create_timer(0.3).timeout
	can_press_buttons = true
	ejectable = true

func _rotation_animation(step):
	if step == "right":
		var tween = create_tween()
		tween.tween_property(key_sprite, "rotation_degrees", key_sprite.rotation_degrees + 90, 0.25)
		await tween.finished
	else:
		var tween = create_tween()
		tween.tween_property(key_sprite, "rotation_degrees", key_sprite.rotation_degrees - 90, 0.25)
		await tween.finished
	$AnimationPlayer.play("press")
	await $AnimationPlayer.animation_finished

func _on_confirm_button_pressed() -> void:
	if not can_press_buttons or ejectable:
		return
	if rotation_order.size() == 5:
		_start_solving()

func _on_reset_button_pressed() -> void:
	if not can_press_buttons:
		return
	ejectable = false
	cur_step = 0
	for child in code_box.get_children():
		child.hide()
	rotation_order.clear()
	for code in code_sprites:
		code.frame = 1
	for code in cur_code:
		code = 1

func _on_eject_button_pressed() -> void:
	get_parent().hide()
	#Add key to inventory
