class_name EnemyState
extends StateBase

enum EnemyStance {
	IDLE, FOLLOWING
}

const SPEED = 200

var position: Vector2
## Can be null.
var character: CharacterState
var seen: bool
var last_seen_position: Vector2
var stance: EnemyStance

static func init_from_enemy(enemy: Enemy, character_state: CharacterState) -> EnemyState:
	var state = EnemyState.new()
	state.position = enemy.global_position
	state.character = character_state
	state.stance = EnemyStance.IDLE
	return state

func can_see_character(vision: RayCast2D) -> bool:
	if character == null:
		return false
	vision.target_position = character.position - position
	vision.force_raycast_update()
	var visible = vision.get_collider()
	return visible is Character

func update_seen(vision: RayCast2D) -> void:
	if can_see_character(vision):
		seen = true
		last_seen_position = character.position
		stance = EnemyStance.FOLLOWING
		on_changed()

func move(new_position: Vector2, vision: RayCast2D) -> void:
	if new_position.is_equal_approx(last_seen_position) and not can_see_character(vision):
		seen = false
		stance = EnemyStance.IDLE
