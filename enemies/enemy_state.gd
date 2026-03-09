class_name EnemyState
extends State

enum EnemyStance {
	IDLE, CHASING, CHECKING
}

const SPEED := 200

var position: Vector2
## Can be null.
var last_seen_position: Vector2
var stance: EnemyStance

static func create(enemy: Enemy) -> EnemyState:
	var state := EnemyState.new()
	state.position = enemy.global_position
	state.stance = EnemyStance.IDLE
	return state

func update_seen(character: CharacterState) -> void:
	if character != null:
		last_seen_position = character.position
		stance = EnemyStance.CHASING
		on_changed()
	elif stance == EnemyStance.CHASING:
		stance = EnemyStance.CHECKING
		on_changed()

func is_chasing() -> bool:
	return stance == EnemyStance.CHASING or stance == EnemyStance.CHECKING 

func move(new_position: Vector2) -> void:
	position = new_position
	if new_position.distance_squared_to(last_seen_position) < 16 and stance != EnemyStance.CHASING:
		stance = EnemyStance.IDLE
	on_changed()
