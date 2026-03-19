extends Node2D

@onready var sanity : int = 100

func _on_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventKey:
		if event.keycode == KEY_ESCAPE:
			pass
