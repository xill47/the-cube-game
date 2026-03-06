extends Control

@export var world: World

func _input(event: InputEvent) -> void:
	if event.is_action_pressed(&"debug_screen"):
		visible = not visible

func _process(_delta: float) -> void:
	var json_dict = ForgeJSONGD.class_to_json(world.state)
	%DebugText.text = JSON.stringify(json_dict, "  ")
