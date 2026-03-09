class_name Plate
extends Node2D

@export var starts_enabled: bool = true
@export var permanent: bool = true

var state: PlateState


func _ready() -> void:
	state.changed.connect(_on_plate_changed)

func _on_plate_changed() -> void:
	$ColorRect.self_modulate.a = 0.5 if state.pressed else 1.0

func _on_plate_area_body_entered(body: Node2D) -> void:
	if body is Character:
		var character := body as Character
		state.step(character.state)

func _on_plate_area_body_exited(body: Node2D) -> void:
	if body is Character:
		state.step(null)
