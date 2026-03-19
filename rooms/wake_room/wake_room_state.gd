class_name WakeRoomState
extends RoomState

var door: DoorState
var cube_stand: CubeHolderState

var wall_buttons: Array[WallButtonState]
var solving_cube := false

@warning_ignore("shadowed_variable")
static func create(door: DoorState, cube_stand: CubeHolderState, \
	wallbutton1: WallButtonState, wallbutton2: WallButtonState, \
	wallbutton3: WallButtonState, wallbutton4: WallButtonState) -> WakeRoomState:
	var state := WakeRoomState.new()
	state.door = door
	state.cube_stand = cube_stand

	state.cube_stand.changed.connect(state._on_cube_changed)
	state.door.door_entered.connect(state.enter_door.bind(door))
	state.wall_buttons = [wallbutton1, wallbutton2, wallbutton3, wallbutton4]
	for button in state.wall_buttons:
		button.changed.connect(state._on_button_changed.bind(button))

	return state

func _on_button_changed(changed_button: WallButtonState) -> void:
	if not changed_button.pressed:
		return

	var idx := wall_buttons.find(changed_button)
	if idx == 0 and _are_none_pressed_except_first():
		solving_cube = true
	elif solving_cube and _are_all_previous_pressed(idx):
		solving_cube = true
	else:
		solving_cube = false

	if _are_all_pressed():
		if solving_cube:
			cube_stand.unlock_stand()
		else:
			for button in wall_buttons:
				button.unpress()


func _are_none_pressed_except_first() -> bool:
	for i in wall_buttons.size() - 1:
		var button := wall_buttons[i + 1]
		if button.pressed:
			return false
	return true


func _are_all_previous_pressed(index: int) -> bool:
	for i in index:
		if not wall_buttons[i].pressed:
			return false
	return true


func _are_all_pressed() -> bool:
	for button in wall_buttons:
		if not button.pressed:
			return false
	return true


func _on_cube_changed() -> void:
	if not cube_stand.cube_present:
		door.unlock()
