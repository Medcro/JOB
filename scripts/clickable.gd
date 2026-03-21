class_name Clickable
extends Area2D

static var is_any_paper_active : bool = false
@export var target : String
@onready var anim: AnimationPlayer = $"../../../AnimationPlayer"
@onready var timer: Timer = $Timer
@onready var papers = $"../../../Papers"
@onready var page_sound: AudioStreamPlayer = $PageSound

var hasPlayed : bool = false 
signal timer_timeout
signal paper_closed

func _ready() -> void:
	timer.one_shot = true
	timer.timeout.connect(_on_timer_timeout)

func _process(delta):
	if Input.is_action_just_pressed("ui_accept") and hasPlayed:
		close_paper()

func _on_input_event(_viewport, event, _shape_idx):
	if event is InputEventMouseButton and event.pressed:
		if event.button_index == MOUSE_BUTTON_LEFT and !hasPlayed and !Clickable.is_any_paper_active:
			open_paper()

func open_paper():
	page_sound.play()
	papers.update_ui()
	
	Clickable.is_any_paper_active = true
	anim.play(target)
	await get_tree().create_timer(0.3).timeout
	hasPlayed = true
	
	timer.start()

func close_paper():
	page_sound.play()
	if papers and papers.get("answer_input"):
		papers.answer_input.release_focus()
	anim.play_backwards(target)
	await get_tree().create_timer(0.3).timeout
	hasPlayed = false
	Clickable.is_any_paper_active = false
	timer.stop() 
	paper_closed.emit()

func _on_timer_timeout():
	timer_timeout.emit()
