extends Node2D
@onready var texture_rect: TextureRect = $TextureRect
@onready var control: Control = $Control

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
	get_tree().change_scene_to_file("res://scenes/Main Menu/main_menu.tscn")
