class_name Character
extends CharacterBody2D

var state: CharacterState
var direction: Vector2

@onready var animation: CharacterAnimation = $CharacterAnimation

func _on_state_provider_state_resolved() -> void:
	state.forcibly_moved.connect(_on_force_movement)


func _on_force_movement() -> void:
	if not global_position.is_equal_approx(state.position):
		global_position = state.position


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed(&"interact") and state.can_interact():
		state.interact(get_tree())
		animation.interact()
	if event.is_action_pressed(&"aim") and state.can_aim():
		state.start_aiming()
	if event.is_action_released(&"aim") and state.stance == state.CharacterStance.AIMING:
		state.stop_aiming()
	if event.is_action_pressed(&"shoot") and state.can_fire():
		state.fire(get_tree())
		animation.fire()

func _physics_process(_delta: float) -> void:
	if state.can_move():
		direction = Input.get_vector(&"move_left", &"move_right", &"move_up", &"move_down")
		velocity = direction * CharacterState.SPEED
		if state.CharacterStance.MOVEMENT or state.CharacterStance.RUNNING:
			animation.character_direction = direction.round()
		move_and_slide()
		state.move(global_position)


func _on_interactable_area_area_entered(area: Area2D) -> void:
	var interactable := area as Interactable
	if interactable != null:
		state.set_interactable_in_range(interactable.state)


func _on_interactable_area_area_exited(area: Area2D) -> void:
	var interactable := area as Interactable
	if state.interactable_in_range == interactable.get_state():
		state.set_interactable_in_range(null)
