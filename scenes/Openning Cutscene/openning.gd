extends Control

@onready var text = $text
@onready var openning_video = $openning_video
@onready var openning_bg: Panel = $openning_bg 

func _ready() -> void:
	# 1. SETUP: The video is fully opaque, but hidden BEHIND the Panel.
	openning_video.modulate.a = 1.0 
	openning_bg.modulate.a = 1.0        
	text.modulate.a = 1.0           
	text.visible_ratio = 0.0        
	
	# This forces Godot to connect the video's finish line to the scene change
	if not openning_video.finished.is_connected(_on_openning_video_finished):
		openning_video.finished.connect(_on_openning_video_finished)
	# -------------------------------------

	# 2. THE ANTI-SNAP TRICK: Start the video, wait two frames to load, then pause.
	openning_video.play()
	await get_tree().process_frame
	await get_tree().process_frame
	openning_video.paused = true
	
	# 3. TYPEWRITER EFFECT: Type out the text over 3 seconds
	var type_tween = create_tween()
	type_tween.tween_property(text, "visible_ratio", 1.0, 3.0)
	
	# 4. Wait a total of 5 seconds (3 sec typing + 2 sec reading)
	await get_tree().create_timer(5.0).timeout
	
	# 5. CROSSFADE: Fade out the text AND the Panel over 1.5 seconds.
	var crossfade_tween = create_tween().set_parallel(true)
	crossfade_tween.tween_property(text, "modulate:a", 0.0, 1.5)
	crossfade_tween.tween_property(openning_bg, "modulate:a", 0.0, 1.5)
	
	# 6. UNPAUSE: Resume the video the moment the Panel is fully transparent.
	await crossfade_tween.finished
	openning_video.paused = false 


func _on_openning_video_finished() -> void:
	# The video is over. Fade in the game music and load the actual game!
	MusicManager.play_game()
	Fade.load_scene("res://scenes/Game/game.tscn")
