extends Node2D

var camera_position: Vector2

@onready var camera := $Camera2D

func camera_move(destination):
	var tween = create_tween()
	tween.tween_property(camera, "position", destination, 0.5)


func _on_pos_area_entered(_area: Area2D, source) -> void:
	var destination = source.position
	camera_move(destination)
