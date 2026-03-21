extends Sprite2D
@onready var pop: AudioStreamPlayer = $Pop

func _on_input_event(_viewport, event, _shape_idx):
	if event is InputEventMouseButton and event.pressed:
		if event.button_index == MOUSE_BUTTON_LEFT:
			pop.play()
			await get_tree().create_timer(0.3).timeout
			queue_free()
			
