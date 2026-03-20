extends Node2D
@onready var q_container: VBoxContainer = $paper1/VBoxContainer
@onready var a_container: VBoxContainer = $paper2/VBoxContainer

var quiz_items = [
	{"q": "Capital of France?", "a": "Paris"},
	{"q": "Square root of 16?", "a": "4"},
	{"q": "Color of an emerald?", "a": "Green"}
]

func generate_split_quiz():
	quiz_items.shuffle()
	
	for item in quiz_items:
		var q_label = Label.new()
		q_label.text = item["q"]
		q_container.add_child(q_label)
		
		var a_input = LineEdit.new()
		a_input.placeholder_text = "???"
		a_input.set_meta("correct_answer", item["a"])
		a_container.add_child(a_input)
		
func check_all_answers():
	for input in a_container.get_children():
		var user_text = input.text.strip_edges().to_lower()
		var correct_text = input.get_meta("correct_answer").to_lower()
		
		if user_text == correct_text:
			input.modulate = Color.GREEN
		else:
			input.modulate = Color.RED
