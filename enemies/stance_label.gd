extends Label

@onready var state: EnemyState = (owner as Enemy).state

func _ready() -> void:
	state.changed.connect(_on_state_changed)
	
func _on_state_changed() -> void:
	text = EnemyState.EnemyStance.keys()[state.stance]
