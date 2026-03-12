class_name CharacterAnimation
extends Node2D

@export var directions: Dictionary

var character_direction: Vector2
var state_name :String

@onready var animation_tree := $AnimationTree
@onready var state: CharacterState = (owner as Character).state

func _ready() -> void:
	state.changed.connect(_on_state_changed)

func _on_state_changed():
	if state.stance == state.CharacterStance.MOVEMENT:
		animation_tree.set("parameters/Stance/transition_request", "walk")
	if state.stance == state.CharacterStance.RUNNING:
		animation_tree.set("parameters/Stance/transition_request", "run")
	if state.stance == state.CharacterStance.IDLE:
		animation_tree.set("parameters/Stance/transition_request", "idle")
	if state.stance == state.CharacterStance.AIMING:
		animation_tree.set("parameters/Stance/transition_request", "aim")

func eight_to_four_direction() -> Vector2:
	var anim_dir_calc: Vector2
	if character_direction == Vector2(-1,-1) or character_direction == Vector2(-1, 1):
		anim_dir_calc = Vector2.LEFT
	if character_direction == Vector2(1,-1) or character_direction == Vector2(1, 1):
		anim_dir_calc = Vector2.RIGHT
	return anim_dir_calc

func _process(_delta: float) -> void:
	if state.stance == state.CharacterStance.AIMING or state.stance == state.CharacterStance.IDLE:
		var angle = get_angle_to(get_global_mouse_position())
		character_direction = Vector2.from_angle(angle).round()


	else:
		var anim_dir = eight_to_four_direction()
		state_name = directions[anim_dir]
		if state.stance == state.CharacterStance.MOVEMENT:
			animation_tree.set("parameters/Walk/transition_request", state_name)
		if state.stance == state.CharacterStance.RUNNING:
			animation_tree.set("parameters/Run/transition_request", state_name)
		if state.stance == state.CharacterStance.IDLE:
			animation_tree.set("parameters/Idle/transition_request", state_name)
