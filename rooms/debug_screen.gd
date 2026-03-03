extends PanelContainer

@onready var context: RoomContext = %Context

func _process(_delta: float) -> void:
	var json_dict = ForgeJSONGD.class_to_json(context.room)
	%DebugText.text = JSON.stringify(json_dict, "  ")
