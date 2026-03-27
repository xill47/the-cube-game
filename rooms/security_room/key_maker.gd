class_name KeyMaker
extends Interactable

@export var puzzle: Control

var state: KeyMakerState

func _ready() -> void:
	state.changed.connect(_on_state_changed)
	state.maker_opened.connect(open_ui)

func get_state() -> InteractableState:
	return state

func open_ui():
	puzzle.show()

func _on_state_changed():
	set_deferred("monitorable", false)
	set_deferred("monitoring", false)
