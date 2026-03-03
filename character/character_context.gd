class_name CharacterContext
extends Node

var character: CharacterState

func _ready() -> void:
	character = CharacterState.new()

func fire() -> void:
	character.fire()
	await get_tree().create_timer(CharacterState.FIRE_COOLDOWN).timeout
	character.is_fire_cooldown = false
