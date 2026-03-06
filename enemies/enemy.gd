class_name Enemy
extends CharacterBody2D

@export var character: Character

var state: EnemyState

func _enter_tree() -> void:
	if state == null:
		if character != null:
			state = EnemyState.init_from_enemy(self, character.state)
		else:
			state = EnemyState.init_from_enemy(self, null)

func _ready() -> void:
	state.changed.connect(_on_state_changed)

func _on_state_changed() -> void:
	if state.seen:
		%Navigation.target_position = state.last_seen_position

func _physics_process(_delta: float) -> void:
	state.update_seen(%Vision)
	if state.seen:
		var next_position = %Navigation.get_next_path_position()
		velocity = (next_position - position).normalized() * EnemyState.SPEED
		move_and_slide()
		state.position = global_position
