class_name Clickable
extends Area2D

static var is_any_paper_active : bool = false
@export var target : String
@onready var anim: AnimationPlayer = $"../../AnimationPlayer"
@onready var timer: Timer = $Timer
@onready var papers: Node2D = $"../../Papers"

var quiz_generated = false
var current_question_index : int = 0

var hasPlayed : bool = false 
signal timer_timeout
signal paper_closed

@onready var question_label = $"../../Papers/paper1/VBoxContainer/Label"
@onready var answer_input = $"../../Papers/paper2/VBoxContainer/LineEdit"

var quiz_items = [
	# --- Sorting Numbers ---
	{"q": "Sort largest to smallest: 0.250, 5, 6, 1, 9", "a": "9, 6, 5, 1, 0.250"},
	{"q": "Sort descending: 6/7, 6/9, 9/6, 4/20, 6/6", "a": "9/6, 6/6, 6/7, 6/9, 4/20"},
	{"q": "Sort backwards: 0.6810, 0.603, 0.687, 0.631, 0.6313", "a": "0.687, 0.6810, 0.6313, 0.631, 0.603"},
	{"q": "Sort diminishing order: 3/4, 0.85, 7/10, 0.71, 4/5", "a": "0.85, 4/5, 3/4, 0.71, 7/10"},
	{"q": "Sort from the biggest: 5/8, 0.60, 2/3, 0.65, 7/11", "a": "2/3, 0.65, 7/11, 5/8, 0.60"},
	{"q": "Sort largest to smallest: 696, 969, 699, 996, 966", "a": "996, 969, 966, 699, 696"},
	{"q": "Sort descending: 373, -337, 733, -733, -373", "a": "733, 373, -337, -373, -733"},
	{"q": "Sort backwards: 42, 7, 100, 5, 12", "a": "100, 42, 12, 7, 5"},
	{"q": "Sort diminishing order: 7/8, 0.88, 0.80, 5/6, 0.85", "a": "0.88, 7/8, 0.85, 5/6, 0.80"},
	{"q": "Sort from the biggest: -15, -400, -2, -99, -250", "a": "-2, -15, -99, -250, -400"},
	{"q": "Sort smallest to largest: 188, -188, 88, -8, 0", "a": "-188, -8, 0, 88, 188"},
	{"q": "Sort ascending: -0.7, 2/5, -3/4, 0.45, -1/2", "a": "-3/4, -0.7, -1/2, 2/5, 0.45"},
	{"q": "Sort increasingly bigger: -272, -722, -27, -72, -277", "a": "-722, -277, -272, -72, -27"},
	{"q": "Sort from the smallest: 2.5, -3, 1/2, 4, 0.1", "a": "-3, 0.1, 2.5, 1/2, 4"},
	{"q": "Sort increasing magnitude: 5/9, -1.2, 0.50, -1/2, 0.55", "a": "-1.2, -1/2, 0.50, 0.55, 5/9"},
	{"q": "Sort smallest to largest: 99, 12, 88, 33, 76", "a": "12, 33, 76, 88, 99"},
	{"q": "Sort ascending: 8, 7, -7, -8, 87", "a": "-8, -7, 7, 8, 87"},
	{"q": "Sort increasingly bigger: 1/4, 0.8, 2, 1/10, 0.5", "a": "1/10, 1/4, 0.5, 0.8, 2"},
	{"q": "Sort from the smallest: -82, -7, -13, 73, -37", "a": "-82, -37, -13, -7, 73"},
	{"q": "Sort increasing magnitude: -3.5, -3.9, 2.6, -4.2, -3.7", "a": "-4.2, -3.9, -3.7, -3.5, 2.6"},

	# --- Sorting Letters ---
	{"q": "Sort letters reverse order: Q, M, V, F, L", "a": "V, Q, M, L, F"},
	{"q": "Sort letters back to front: K, B, X, P, W", "a": "X, W, P, K, B"},
	{"q": "Sort letters backwards: H, Z, R, J, S", "a": "Z, S, R, J, H"},
	{"q": "Sort letters reverse order: T, N, D, G, Y", "a": "Y, T, N, G, D"},
	{"q": "Sort letters back to front: E, A, I, U, O", "a": "U, O, I, E, A"},
	{"q": "Sort letters backwards: L, Z, B, R, V", "a": "Z, V, R, L, B"},
	{"q": "Sort letters reverse order: I, N, T, E, R", "a": "T, R, N, I, E"},
	{"q": "Sort letters back to front: V, I, E, W", "a": "W, V, I, E"},
	{"q": "Sort letters backwards: A, N, X, I, E, T, Y", "a": "Y, X, T, N, I, E, A"},
	{"q": "Sort letters reverse order: N, E, R, V, O, U, S", "a": "V, U, S, R, O, N, E"},
	{"q": "Sort letters in order: J, O, B", "a": "B, O, J"},
	{"q": "Sort letters front to back: P, F, X, H, Q", "a": "F, H, P, Q, X"},
	{"q": "Sort letters alphabetically: J, C, Y, K, A", "a": "A, C, K, J, Y"},
	{"q": "Sort letters in order: W, G, B, S, M", "a": "B, G, M, S, W"},
	{"q": "Sort letters front to back: U, N, E, A, S, Y", "a": "A, E, N, S, U, Y"},
	{"q": "Sort letters alphabetically: F, E, A, R", "a": "A, E, F, R"},
	{"q": "Sort letters in order: P, A, N, I, C", "a": "A, C, I, N, P"},
	{"q": "Sort letters front to back: F, R, I, G, H, T", "a": "F, G, H, I, R, T"},
	{"q": "Sort letters alphabetically: S, C, A, R, Y", "a": "A, C, R, S, Y"},
	{"q": "Sort letters in order: B, R, E, A, T, H", "a": "A, B, E, H, R, T"},

	# --- Basic Math ---
	{"q": "What is 1 + 1?", "a": "2"},
	{"q": "What is 2 x 3?", "a": "6"},
	{"q": "What is 2 + 3?", "a": "5"},
	{"q": "What is the smallest prime number?", "a": "2"},
	{"q": "What is 5 + 10 + 15?", "a": "30"},
	{"q": "What is 2^8?", "a": "256"},
	{"q": "What is 49 - 56?", "a": "-7"},
	{"q": "What is 100 / 20?", "a": "5"},
	{"q": "What is 100 / 25?", "a": "4"},
	{"q": "What is 8 / 2 (2 + 2)?", "a": "16"},
	{"q": "What is 8 x 8 + 8 - 8 / 8?", "a": "71"},
	{"q": "What is 9 + 10?", "a": "19"},
	{"q": "What is 1 + 2 + 3 + 4 + 5?", "a": "15"},
	{"q": "What is -99292 x 299 / 29219 x 0 + 1?", "a": "1"},
	{"q": "What is 89 - 107?", "a": "-18"},
	{"q": "What is 69 + 67?", "a": "136"},
	{"q": "What is 5^5?", "a": "3125"},
	{"q": "What is 12 x 5?", "a": "60"},
	{"q": "What is 16 + 15?", "a": "31"},
	{"q": "What is 111 + 999?", "a": "1110"},

	# --- Number Patterns ---
	{"q": "Next number: 2, 4, 8, 16, ...", "a": "32"},
	{"q": "Fill in blank: 1, ..., 5, 7, 9, 11", "a": "3"},
	{"q": "Next number: 1, 2, 4, 7, 11, ...", "a": "16"},
	{"q": "Next number: 0, 1, 1, 2, 3, 5, 8, ...", "a": "13"},
	{"q": "Next number: 1, 8, 27, 64, ...", "a": "125"},
	{"q": "Fill in blank: ..., -15, -10, -5, 0", "a": "-20"},
	{"q": "Next number: 160, 80, 40, 20, ...", "a": "10"},
	{"q": "Next number: 48, 24, 12, 6, ...", "a": "3"},
	{"q": "Next number: 50, 49, 47, 44, 40, ...", "a": "35"},
	{"q": "Next number: 21, 15, 10, 6, 3, ...", "a": "1"},

	# --- Word Problems ---
	{"q": "3 pizzas, 8 slices each. 4 friends share equally. Each gets?", "a": "6"},
	{"q": "235 books. 123 out, 56 back. Total now?", "a": "168"},
	{"q": "150 unread emails. 85 new. 40 archived. Current total?", "a": "195"},
	{"q": "480 mins work. 45 mtg, 90 review, 60 lunch. Mins left?", "a": "285"},
	{"q": "6 interviews. 45 mins each. Total minutes?", "a": "270"},

	# --- Proofreading ---
	{"q": "Wrong word: 'I hope your going to the party tonight...'", "a": "your"},
	{"q": "Wrong word: '...because we were way to busy...'", "a": "to"},
	{"q": "Wrong word: '...stay late... tonight then have to come...'", "a": "then"},
	{"q": "Wrong word: '...please make sure you grab an uniform...'", "a": "an"},
	{"q": "Wrong word: '...so please bare with me...'", "a": "bare"}
]

func _ready() -> void:
	timer.one_shot = true
	timer.timeout.connect(_on_timer_timeout)
	quiz_items.shuffle()
	answer_input.text_submitted.connect(_on_answer_submitted)

func _process(_delta):
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
	update_ui_text()
	
	Clickable.is_any_paper_active = true
	anim.play(target)
	await get_tree().create_timer(0.3).timeout
	hasPlayed = true
	answer_input.grab_focus()
	timer.start()

func close_paper():
	anim.play_backwards(target)
	await get_tree().create_timer(0.3).timeout
	hasPlayed = false
	Clickable.is_any_paper_active = false
	timer.stop()
	paper_closed.emit()

func _on_timer_timeout():
	print("Timer has finished!")
	timer_timeout.emit()
	
func update_ui_text():
	if current_question_index < quiz_items.size():
		var data = quiz_items[current_question_index]
		question_label.text = data["q"]
		answer_input.text = "" 
		answer_input.modulate = Color.WHITE
	else:
		question_label.text = "All Done!"
		answer_input.visible = false
		

func _on_answer_submitted(submitted_text: String):
	if current_question_index >= quiz_items.size():
		return

	var correct_ans = quiz_items[current_question_index]["a"].to_lower()
	var user_ans = submitted_text.replace(" ", "").to_lower()
	var real_ans = correct_ans.replace(" ", "").to_lower()

	if user_ans == correct_ans:
		print("Correct!")
		current_question_index += 1
		
		update_ui_text()
		
		if current_question_index < quiz_items.size():
			await get_tree().process_frame
			answer_input.grab_focus()
	else:
		print("Wrong!")
		answer_input.text = "" 
		answer_input.grab_focus()

func _on_submit_button_pressed() -> void:
	_on_answer_submitted(answer_input.text)
