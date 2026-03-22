extends Node

@onready var main_menu = $Main_Menu
@onready var game = $Game

var fade_time: float = 2.0 
var main_menu_music = preload("res://assets/Audio/Music/Menu Screen.ogg")
var game_music = preload("res://assets/Audio/Music/Game Music.ogg")

# NEW: We store the active tween here so we can cancel it if needed!
var current_tween: Tween 

func _ready() -> void:
	main_menu.stream = main_menu_music
	game.stream = game_music
	main_menu.volume_db = -80.0
	game.volume_db = -80.0

func play_mainmenu(transition_time: float = fade_time) -> void:
	if main_menu.playing and main_menu.volume_db == 0.0:
		return
		
	# 1. KILL ANY ACTIVE FADES
	if current_tween:
		current_tween.kill()
		
	# 2. ONLY START THE TRACK IF IT ISN'T ALREADY PLAYING
	if not main_menu.playing:
		main_menu.play()
	
	if transition_time > 0.0:
		current_tween = create_tween().set_parallel(true)
		current_tween.set_trans(Tween.TRANS_SINE) 
		current_tween.tween_property(game, "volume_db", -80.0, transition_time)
		current_tween.tween_property(main_menu, "volume_db", 0.0, transition_time)
		current_tween.chain().tween_callback(game.stop)
	else:
		game.stop()
		game.volume_db = -80.0
		main_menu.volume_db = 0.0

func play_game(transition_time: float = fade_time) -> void:
	if game.playing and game.volume_db == 0.0:
		return
		
	# 1. KILL ANY ACTIVE FADES
	if current_tween:
		current_tween.kill()
		
	# 2. ONLY START THE TRACK IF IT ISN'T ALREADY PLAYING
	if not game.playing:
		game.play()
	
	if transition_time > 0.0:
		current_tween = create_tween().set_parallel(true)
		current_tween.set_trans(Tween.TRANS_SINE)
		current_tween.tween_property(main_menu, "volume_db", -80.0, transition_time)
		current_tween.tween_property(game, "volume_db", 0.0, transition_time)
		current_tween.chain().tween_callback(main_menu.stop)
	else:
		main_menu.stop()
		main_menu.volume_db = -80.0
		game.volume_db = 0.0

func fade_all(transition_time: float = fade_time) -> void:
	if current_tween:
		current_tween.kill()
		
	current_tween = create_tween().set_parallel(true)
	if main_menu.playing:
		current_tween.tween_property(main_menu, "volume_db", -80.0, transition_time)
	if game.playing:
		current_tween.tween_property(game, "volume_db", -80.0, transition_time)
		
	current_tween.chain().tween_callback(main_menu.stop)
	current_tween.chain().tween_callback(game.stop)
