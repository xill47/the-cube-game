class_name Safe
extends Interactable

@export var puzzle: Node2D

var state: SafeState

@onready var sprite = $Sprite

func _ready() -> void:
	state.changed.connect(_on_state_changed)
	state.safe_opened.connect(open_ui)

func get_state() -> InteractableState:
	return state

func open_ui():
	puzzle.show()
	puzzle.safe = self

func _on_state_changed():
	if state.locked:
		sprite.frame_coords.x = 0
	else:
		sprite.frame_coords.x = 1
		set_deferred("monitorable", false)
		set_deferred("monitoring", false)
