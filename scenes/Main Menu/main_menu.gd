extends Control

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	MusicManager.play_mainmenu(0.0)
	get_tree().paused = false


func _on_normal_mouse_entered() -> void:
	$Hover.play()

func _on_normal_pressed() -> void:
	SfxManager.button_clicknormal()
	MusicManager.fade_all(2.0)
	Fade.load_scene("res://scenes/Openning Cutscene/openning.tscn")


func _on_endless_mouse_entered() -> void:
	$Hover.play()

func _on_endless_pressed() -> void:
	SfxManager.button_click()


func _on_settings_mouse_entered() -> void:
	$Hover.play()

func _on_settings_pressed() -> void:
	SfxManager.button_click()
	get_tree().change_scene_to_file("res://scenes/Main Menu/settings.tscn")


func _on_exit_mouse_entered() -> void:
	$Hover.play()

func _on_exit_pressed() -> void:
	SfxManager.button_click()
	get_tree().quit()
