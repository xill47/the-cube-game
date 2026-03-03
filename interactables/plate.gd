extends Node2D

@onready var context: PlateContext = %Context

func _ready() -> void:
	context.plate.changed.connect(_on_plate_changed)

func _on_plate_changed() -> void:
	$ColorRect.self_modulate.a = 0.5 if context.plate.pressed else 1.0

func _on_plate_area_body_entered(body: Node2D) -> void:
	if body is Character:
		var character = body.context.character
		context.plate.step(character)

func _on_plate_area_body_exited(body: Node2D) -> void:
	if body is Character:
		context.plate.step(null)
