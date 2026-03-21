extends Node2D
@onready var texture_rect: TextureRect = $TextureRect
@onready var control: Control = $Control
@onready var hover_sound: AudioStreamPlayer = $HoverSound
@onready var select_sound: AudioStreamPlayer = $SelectSound

func _ready() -> void:
	GlobalData.good_ending = true
	SaveManager.save_game()
	control.visible = false
	await get_tree().create_timer(3.0).timeout
	texture_rect.texture = load("res://assets/Good Ending/GoodEnding2.jpg")
	control.visible = true

func _on_continue_button_button_up() -> void:
	pass # Replace with function body.

func _on_end_button_button_up() -> void:
	await get_tree().create_timer(0.4).timeout
	get_tree().change_scene_to_file("res://scenes/Main Menu/main_menu.tscn")

func _on_button_pressed() -> void:
	select_sound.play()

func _on_button_mouse_entered() -> void:
	hover_sound.play()
