extends Node2D

@export var smoke: PackedScene
@onready var sanity_bar = $CanvasLayer/SanityBar
@onready var qte: Control = $CanvasLayer/QTE
@onready var qte_timer: Timer = $CanvasLayer/QTE/QTETimer
@onready var timer: Timer = $Timer
@onready var environment: Panel = $Environment
@onready var background: Sprite2D = $Environment/Background
@onready var light: Sprite2D = $Environment/Light
@onready var person: Sprite2D = $Environment/Person
@onready var table: Sprite2D = $Environment/Table
@onready var paper_answer: Sprite2D = $Environment/PaperAnswer
@onready var paper_question: Sprite2D = $Environment/PaperQuestion
@onready var lamp: Sprite2D = $Environment/Lamp
@onready var papers: Node2D = $Papers
@onready var canvas_layer: CanvasLayer = $CanvasLayer
@onready var clickable_2: Clickable = $Environment/PaperAnswer/Clickable2
@onready var clickable: Clickable = $Environment/PaperQuestion/Clickable
@onready var heartbeat: AudioStreamPlayer = $Audio/Heartbeat
@onready var sanity_up: AudioStreamPlayer = $Audio/SanityUp
@onready var sanity_down: AudioStreamPlayer = $Audio/SanityDown

var sanity : float = 100.0 
var drain_rate : float = 1.0
var game_over : bool = false
var isRed : bool = false

func _ready():
	qte.hide()
	qte.qte_finished.connect(start_random_timer_qte)
	qte.qte_failed.connect(decrease_sanity)
	qte.qte_success.connect(increase_sanity)
	papers.answer_correct.connect(increase_sanity)
	papers.win_condition.connect(good_ending)
	start_random_timer()
	sanity_bar.max_value = 100
	start_random_timer_qte()
	spawn_random_sprite()

func _process(delta):
	if not game_over:
		if sanity > 0:
			sanity -= drain_rate * delta
			sanity_bar.value = sanity 
		else:
			game_over = true
			bad_ending()
		
		if sanity > 100:
			sanity = 100
		
func start_random_timer_qte():
	var random_wait = randf_range(5.0, 15.0) 
	qte_timer.wait_time = random_wait
	qte_timer.start()

func _on_qte_timer_timeout() -> void:
	heartbeat.play()
	await get_tree().create_timer(3.0).timeout
	qte.show() 
	qte.start_new_round()
	
func start_random_timer():
	var wait_time = randf_range(10.0, 30.0)
	print("starting time ", wait_time)
	timer.start(wait_time)

func _on_timer_timeout():
	if isRed:
		print("spawn")
		spawn_random_sprite()
	else:
		change_environment()
		isRed = true
	start_random_timer()

func change_environment():
	background.texture = load("res://assets/red/Red-1.png")
	light.texture = load("res://assets/red/AddBelowLight,AboveTable.png")
	person.texture = load("res://assets/red/Red-2.png")
	table.texture = load("res://assets/red/Red-3.png")
	paper_answer.texture = load("res://assets/red/Red-4.png")
	paper_question.texture = load("res://assets/red/Red-5.png")
	lamp.texture = load("res://assets/red/Red-6.png")
	
func decrease_sanity():
	sanity -= 20
	sanity_down.play()

func increase_sanity():
	sanity += 10
	sanity_up.play()

func bad_ending():
	canvas_layer.visible = false
	clickable.visible = false
	clickable_2.visible = false
	background.texture = load("res://assets/Bad Ending/End-1.png")
	light.texture = load("res://assets/Bad Ending/AddBelowLight,AboveTable.png")
	person.texture = load("res://assets/Bad Ending/End-2.png")
	table.texture = load("res://assets/Bad Ending/End-4.png")
	paper_answer.texture = load("res://assets/Bad Ending/End-5.png")
	paper_question.texture = load("res://assets/Bad Ending/End-6.png")
	lamp.texture = load("res://assets/Bad Ending/End-7.png")
	await get_tree().create_timer(4.0).timeout
	person.texture = load("res://assets/Bad Ending/End-3.png")
	shake_sprite(person)
	await get_tree().create_timer(4.0).timeout
	GlobalData.bad_ehding = true
	SaveManager.save_game()
	get_tree().change_scene_to_file("res://scenes/Main Menu/main_menu.tscn")

func good_ending():
	await get_tree().create_timer(1.0).timeout
	get_tree().change_scene_to_file("res://scenes/Ending/good_ending.tscn")

func shake_sprite(sprite: Sprite2D, intensity: float = 5.0, duration: float = 3.8):
	var original_pos = sprite.position
	var tween = create_tween()
	
	for i in range(4):
		var drift_pos = original_pos + Vector2(randf_range(-intensity, intensity), randf_range(-intensity, intensity))
		tween.tween_property(sprite, "position", drift_pos, duration / 8.0)
		tween.tween_property(sprite, "position", original_pos, duration / 8.0)
		
func spawn_random_sprite():
	if smoke == null:
		return
	var screen_size = get_viewport_rect().size
	
	var random_x = randf_range(-screen_size.x/2, screen_size.x/2)
	var random_y = randf_range(-screen_size.y/2, screen_size.y/700)
	
	var new_sprite = smoke.instantiate()
	new_sprite.global_position = Vector2(random_x, random_y)
	
	new_sprite.tree_exited.connect(_on_smoke_cleared)
	
	add_child(new_sprite)
	print("spawn at ", random_x, ", ", random_y)
	
	drain_rate = 2.0

func _on_smoke_cleared():
	if game_over:
		return
	
	if get_tree() == null:
		return
		
	await get_tree().process_frame 
	
	var smokes_left = get_tree().get_nodes_in_group("Smokes").size()
	
	if smokes_left == 0:
		drain_rate = 1.0
