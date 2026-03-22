extends Control

@onready var pause_menu = $PausePopUp

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	pause_menu.visible = false

func _on_pause_button_mouse_entered() -> void:
	$Hover.play()

func _on_pause_button_pressed() -> void:
	SfxManager.button_click()
	pause_menu.visible = true
	get_tree().paused = true


func _on_resume_button_mouse_entered() -> void:
	$Hover.play()

func _on_resume_button_pressed() -> void:
	SfxManager.button_click()
	get_tree().paused = false
	pause_menu.visible = false

func _on_reset_button_mouse_entered() -> void:
	$Hover.play()

func _on_reset_button_pressed() -> void:
	SfxManager.button_click()
	get_tree().paused = false
	Fade.reload_scene()

func _on_exit_button_mouse_entered() -> void:
	$Hover.play()

func _on_exit_button_pressed() -> void:
	get_tree().paused = false
	SfxManager.button_click()
	MusicManager.play_mainmenu()
	Fade.load_scene("res://scenes/Main Menu/main_menu.tscn")
