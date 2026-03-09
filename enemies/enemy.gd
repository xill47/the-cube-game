class_name Enemy
extends CharacterBody2D

var state: EnemyState
var character: CharacterState

func _ready() -> void:
	state.changed.connect(_on_state_changed)
	assert(character != null)
	character.changed.connect(_on_character_changed)

func _on_state_changed() -> void:
	if state.is_chasing():
		%Navigation.target_position = state.last_seen_position

func _on_character_changed() -> void:
	%Vision.target_position = to_local(character.position)

func _physics_process(_delta: float) -> void:
	var collider := %Vision.get_collider() as Character
	if collider != null:
		state.update_seen(collider.state)
	else:
		state.update_seen(null)
	if state.is_chasing():
		var next_position: Vector2 = %Navigation.get_next_path_position()
		velocity = (next_position - global_position).normalized() * EnemyState.SPEED
		move_and_slide()
		state.move(global_position)
