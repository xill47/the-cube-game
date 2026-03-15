extends Node2D

@export var character : Node2D

var interactables : Array[Node]

func _ready() -> void:
	interactables = get_children()

func _process(_delta: float) -> void:
	for inter: Node2D in interactables:
		if character.position.y < inter.position.y:
			inter.z_index = 1
		else:
			inter.z_index = 0
