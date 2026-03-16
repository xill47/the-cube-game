class_name CharacterState
extends State

signal forcibly_moved

enum CharacterStance {
	IDLE, MOVEMENT, RUNNING, AIMING, ANIMATION
}

const FIRE_COOLDOWN := 1.5
const SPEED := 320
const MAX_AMMO := 8
const INTERACT_TIME := 0.25

var position: Vector2
var stance: CharacterStance
var moved_rooms: int

var live_ammo: int
var is_fire_cooldown: bool

var interactable_in_range: InteractableState

static func create(character: Character) -> CharacterState:
	var state := CharacterState.new()
	state.position = character.global_position
	state.stance = CharacterStance.IDLE
	state.live_ammo = MAX_AMMO
	state.is_fire_cooldown = false
	return state

func can_move() -> bool:
	return stance != CharacterStance.AIMING and stance != CharacterStance.ANIMATION

func move(new_position: Vector2) -> void:
	var prev_stance: CharacterStance = stance
	if position.is_equal_approx(new_position):
		stance = CharacterStance.IDLE
	else:
		stance = CharacterStance.MOVEMENT
	position = new_position
	if prev_stance != stance:
		on_changed()

func force_movement(new_position: Vector2) -> void:
	stance = CharacterStance.IDLE
	position = new_position
	forcibly_moved.emit()
	on_changed()

func can_aim() -> bool:
	return stance != CharacterStance.ANIMATION

func start_aiming() -> void:
	stance = CharacterStance.AIMING
	on_changed()

func stop_aiming() -> void:
	stance = CharacterStance.IDLE
	on_changed()

func can_fire() -> bool:
	return stance == CharacterStance.AIMING \
		and not is_fire_cooldown \
		and live_ammo > 0

func fire(tree: SceneTree) -> void:
	if not can_fire():
		return
	live_ammo -= 1
	is_fire_cooldown = true
	on_changed()
	await tree.create_timer(FIRE_COOLDOWN).timeout
	is_fire_cooldown = false
	on_changed()

func set_interactable_in_range(interactable: InteractableState) -> void:
	interactable_in_range = interactable
	on_changed()

func can_interact() -> bool:
	return interactable_in_range != null and stance == CharacterStance.IDLE

func interact(tree) -> void:
	interactable_in_range.interact()
	stance = CharacterStance.ANIMATION
	on_changed()
	await tree.create_timer(INTERACT_TIME).timeout
	stance = CharacterStance.IDLE
	on_changed()

func move_room() -> void:
	moved_rooms += 1
	on_changed()
