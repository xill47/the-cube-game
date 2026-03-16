class_name CubeHolder
extends Interactable

var state: CubeHolderState

@onready var sprite := $Sprite

func _ready() -> void:
	state.holder_opened.connect(_on_holder_opened)
	state.cube_taken.connect(_cube_taken)

func get_state() -> InteractableState:
	return state

func open_holder():
	state.unlock_stand()

func _on_holder_opened():
	sprite.frame_coords.x = 1

func _cube_taken():
	#Allow player to use Cube
	#Open the door
	sprite.frame_coords.x = 2
