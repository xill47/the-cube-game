class_name Character
extends CharacterBody2D

@onready var context: CharacterContext = %CharacterContext

func _physics_process(_delta: float) -> void:
	if context.character.is_movement_allowed():
		velocity = Input.get_vector("move_left", "move_right", "move_up", "move_down") \
			* CharacterState.SPEED
		move_and_slide()

func _process(_delta: float) -> void:
	if context.character.is_movement_allowed():
		context.character.move_to(global_position)
	else:
		global_position = context.character.position
