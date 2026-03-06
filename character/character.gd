class_name Character
extends CharacterBody2D

var state: CharacterState

func _enter_tree() -> void:
	if state == null:
		state = CharacterState.init_from_character(self)
	else:
		global_position = state.position

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action(&"interact") and state.can_interact():
		state.interact()

func _physics_process(_delta: float) -> void:
	if state.can_move():
		velocity = Input.get_vector(&"move_left", &"move_right", &"move_up", &"move_down") \
			* CharacterState.SPEED
		move_and_slide()
		state.move(global_position)

func _on_interactable_area_area_entered(area: Area2D) -> void:
	if area is Interactable:
		var interactable = area as Interactable
		state.set_interactable_in_range(interactable.state)

func _on_interactable_area_area_exited(area: Area2D) -> void:
	if area is Interactable and state.interactable_in_range == area.state:
		state.set_interactable_in_range(null)
