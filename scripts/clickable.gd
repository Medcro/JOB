class_name Clickable
extends Area2D

static var is_any_paper_active : bool = false
@export var target : String
@onready var anim: AnimationPlayer = $"../../AnimationPlayer"
@onready var timer: Timer = $Timer
@onready var papers: Node2D = $"../../Papers"

var quiz_generated = false

var hasPlayed : bool = false 
signal timer_timeout
signal paper_closed

@onready var q_vbox = $"../../Papers/paper1/VBoxContainer"
@onready var a_vbox = $"../../Papers/paper2/VBoxContainer"

var quiz_items = [
	{"q": "What is 1 + 1?", "a": "2"},
	{"q": "The sun is a...?", "a": "star"},
	{"q": "Godot version?", "a": "4.6"}
]

func _ready() -> void:
	timer.one_shot = true
	timer.timeout.connect(_on_timer_timeout)

func _process(delta):
	if Input.is_action_just_pressed("ui_accept") and hasPlayed:
		close_paper()

func _on_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton and event.pressed:
		if event.button_index == MOUSE_BUTTON_LEFT and !hasPlayed and !Clickable.is_any_paper_active:
			open_paper()
			
	if event is InputEventKey:
		if event.keycode == KEY_SPACE and hasPlayed:
			close_paper()

func open_paper():
	if not quiz_generated:
		generate_quiz()
		quiz_generated = true
	Clickable.is_any_paper_active = true
	anim.play(target)
	await get_tree().create_timer(0.3).timeout
	hasPlayed = true
	timer.start()

func close_paper():
	if check_answers():
		print("win")
	anim.play_backwards(target)
	await get_tree().create_timer(0.3).timeout
	hasPlayed = false
	Clickable.is_any_paper_active = false
	timer.stop()
	paper_closed.emit()

func _on_timer_timeout():
	print("Timer has finished!")
	timer_timeout.emit()

func generate_quiz():
	for n in q_vbox.get_children(): n.queue_free()
	for n in a_vbox.get_children(): n.queue_free()
	
	quiz_items.shuffle()
	
	for item in quiz_items:
		var q_label = Label.new()
		q_label.text = item["q"]
		q_label.add_theme_color_override("font_color", Color.BLACK) # If paper is white
		q_vbox.add_child(q_label)
		
		var a_input = LineEdit.new()
		a_input.placeholder_text = "Answer..."
		a_input.set_meta("correct", item["a"])
		a_vbox.add_child(a_input)
		
func check_answers() -> bool:
	var all_correct = true
	for input in a_vbox.get_children():
		if input is LineEdit:
			var user_ans = input.text.strip_edges().to_lower()
			var real_ans = input.get_meta("correct").to_lower()
			if user_ans != real_ans:
				all_correct = false
	return all_correct
