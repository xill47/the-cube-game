extends Control

@onready var anim_player := $AnimationPlayer
@onready var master_bus := AudioServer.get_bus_index("Master")
@onready var sound_bus := AudioServer.get_bus_index("Sound")
@onready var music_bus := AudioServer.get_bus_index("Music")

func _on_option_label_pressed() -> void:
	anim_player.play("open-options")

func _on_back_button_pressed() -> void:
	anim_player.play("close-options")

func _on_no_button_pressed() -> void:
	anim_player.play("close-exit")

func _on_exit_label_pressed() -> void:
	anim_player.play("open-exit")


func _on_master_slider_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(master_bus, linear_to_db(value))

func _on_sound_slider_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(sound_bus, linear_to_db(value))

func _on_music_slider_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(music_bus, linear_to_db(value))

func _on_yes_button_pressed() -> void:
	get_tree().quit()

func _on_check_box_toggled(toggled_on: bool) -> void:
	if toggled_on:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	if not toggled_on:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
