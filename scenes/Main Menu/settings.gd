extends Control

@onready var sfx_bus_id = AudioServer.get_bus_index("SFX")
@onready var music_bus_id = AudioServer.get_bus_index("Music")


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_back_button_mouse_entered() -> void:
	$Hover.play()

func _on_back_button_pressed() -> void:
	SfxManager.button_click()
	get_tree().change_scene_to_file("res://scenes/Main Menu/main_menu.tscn")


func _on_reset_data_button_mouse_entered() -> void:
	$Hover.play()

func _on_reset_data_button_pressed() -> void:
	SfxManager.button_click()


func _on_music_slider_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(music_bus_id, linear_to_db(value))
	AudioServer.get_bus_volume_db(music_bus_id)

func _on_sfx_slider_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(sfx_bus_id, linear_to_db(value))
	AudioServer.get_bus_volume_db(sfx_bus_id)

func _on_music_slider_drag_ended(value_changed: bool) -> void:
	$VolumeToggle_Music.play()

func _on_sfx_slider_drag_ended(value_changed: bool) -> void:
	$VolumeToggle_SFX.play()
