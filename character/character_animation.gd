class_name CharacterAnimation
extends Node2D

@export var directions: Dictionary

var character_direction: Vector2
var cur_direction: Vector2
var state_name :String

@onready var animation_player := $AnimationPlayer
@onready var animation_tree := $AnimationTree
@onready var state: CharacterState = (owner as Character).state
@onready var idle_sprite := $Idle
@onready var walk_sprite := $Walk
@onready var run_sprite := $Run
@onready var aim_sprite := $Aim
@onready var shoot_sprite := $Shoot

func _ready() -> void:
	state.changed.connect(_on_state_changed)

func _process(_delta: float) -> void:
	if state.stance == state.CharacterStance.AIMING or state.stance == state.CharacterStance.IDLE:
		character_direction = get_local_mouse_position().normalized().round()
	if cur_direction != character_direction:
		_on_dir_change()
		cur_direction = character_direction

func _on_state_changed():
	if state.stance == state.CharacterStance.MOVEMENT:
		animation_tree.set("parameters/Stance/transition_request", "walk")
		walk_sprite.show()
	else:
		walk_sprite.hide()
	if state.stance == state.CharacterStance.RUNNING:
		animation_tree.set("parameters/Stance/transition_request", "run")
		run_sprite.show()
	else:
		run_sprite.hide()
	if state.stance == state.CharacterStance.IDLE:
		animation_tree.set("parameters/Stance/transition_request", "idle")
		idle_sprite.show()
	else:
		idle_sprite.hide()
	if state.stance == state.CharacterStance.AIMING:
		animation_tree.set("parameters/Stance/transition_request", "aim")
		aim_sprite.show()
	else:
		aim_sprite.hide()

func fire():
	animation_tree.set("parameters/Shoot/transition_request", state_name)
	animation_tree.set("parameters/OneShot/request", AnimationNodeOneShot.ONE_SHOT_REQUEST_FIRE)
	shoot_sprite.show()
	aim_sprite.hide()
	state_name = directions[character_direction]
	await get_tree().create_timer(animation_player.get_animation("shoot/down").get_length()).timeout
	shoot_sprite.hide()
	aim_sprite.show()

func _eight_to_four_direction() -> Vector2:
	var anim_dir_calc: Vector2 = character_direction
	if character_direction.x == -1:
		anim_dir_calc = Vector2.LEFT
	if character_direction.x == 1:
		anim_dir_calc = Vector2.RIGHT
	$DirectionLabel.text = str(anim_dir_calc)
	return anim_dir_calc

func _on_dir_change():
	var anim_dir = _eight_to_four_direction()
	var state_name_four = directions[anim_dir]
	state_name = directions[character_direction]
	animation_tree.set("parameters/Aim/transition_request", state_name)
	animation_tree.set("parameters/Idle/transition_request", state_name_four)
	animation_tree.set("parameters/Walk/transition_request", state_name_four)
	animation_tree.set("parameters/Run/transition_request", state_name_four)

func damaged():
	animation_tree.set("parameters/Custom/transition_request", "damaged")
	animation_tree.set("parameters/CustomShot/request", AnimationNodeOneShot.ONE_SHOT_REQUEST_FIRE)

func cutscene(req_cutscene: String):
	animation_tree.set("parameters/Custom/transition_request", req_cutscene)
