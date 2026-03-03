extends Room

@onready var context: RoomContext = %Context

func _ready() -> void:
	context.room.character = %Character.context.character
	context.room.plates.push_back($Plate.context.plate)
