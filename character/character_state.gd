class_name CharacterState
extends RefCounted

signal changed

enum CharacterStance {
	IDLE, MOVEMENT, AIMING, ANIMATION
}

const FIRE_COOLDOWN = 1.5
const SPEED = 320

var position: Vector2
var stance: CharacterStance

var live_ammo: int
var ammo: int

var is_fire_cooldown: bool

func move_to(new_position: Vector2) -> void:
	position = new_position
	changed.emit()

func is_movement_allowed() -> bool:
	return stance != CharacterStance.AIMING and stance != CharacterStance.ANIMATION

func can_fire() -> bool:
	return stance == CharacterStance.AIMING \
		and not is_fire_cooldown \
		and live_ammo > 0

func fire() -> void:
	if not can_fire():
		return
	live_ammo -= 1
	is_fire_cooldown = true
