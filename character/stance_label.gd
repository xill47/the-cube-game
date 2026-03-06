extends Label

@onready var state: CharacterState = (owner as Character).state

func _ready() -> void:
	state.changed.connect(_on_state_changed)
	
func _on_state_changed() -> void:
	text = CharacterState.CharacterStance.keys()[state.stance]
