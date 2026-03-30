class_name TunnelLever
extends Interactable

@export var door1 := Node2D
@export var door2 := Node2D
@export var tunnel := Node2D

var pannel_visible: bool = false
var state: TunnelLeverState

@onready var sprite = $Sprite

func _ready() -> void:
	state.changed.connect(_on_pressed)

func get_state() -> InteractableState:
	return state

func _unhandled_input(event: InputEvent) -> void:
	if event.is_pressed() and not event.is_action("interact") and not event.is_action("toggle_cube"):
		if event is InputEventKey or event.is_action("aim"):
			if pannel_visible:
				%PannelBack.hide()
				pannel_visible = false

func _on_pressed():
	%PannelBack.show()
	pannel_visible = true

func solved():
	tunnel.solved = true
	%PannelBack.hide()
	door1.state.change_state()
	door2.state.change_state()
	if state.pressed:
		sprite.frame_coords.x = 1
	else:
		sprite.frame_coords.x = 0
