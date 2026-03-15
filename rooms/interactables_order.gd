extends Node2D

@export var character : Node2D

var interactables : Array[Node]
var room_empty := false

func _ready() -> void:
	interactables = get_children()
	if interactables.is_empty():
		room_empty = true

func _process(_delta: float) -> void:
	if room_empty:
		return
	for inter: Node2D in interactables:
		if character.position.y < inter.position.y:
			inter.z_index = 1
		else:
			inter.z_index = 0
