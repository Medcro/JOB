extends Control

@onready var background = $Background
@onready var success_zone = $Background/SuccessZone
@onready var needle = $Background/Needle

signal qte_finished
signal qte_failed

var speed: float = 300.0 
var is_active: bool = false
	
var required_successes: int = 3
var current_successes: int = 0
	
func _process(delta):
	if not is_active: 
		return
	
	needle.position.x += speed * delta
	
	if needle.position.x > background.size.x:
		fail_skill_check()
	
func _unhandled_input(event):
	if is_active and event.is_action_pressed("ui_accept"): 
		evaluate_hit()
	
func start_new_round():
	needle.position.x = 0
	var min_x = 50.0 
	var max_x = background.size.x - success_zone.size.x 
	
	success_zone.position.x = randf_range(min_x, max_x)
	
	is_active = true
	
func evaluate_hit():
	is_active = false 
	
	var zone_start = success_zone.position.x
	var zone_end = success_zone.position.x + success_zone.size.x
	
	if needle.position.x >= zone_start and needle.position.x <= zone_end:
		current_successes += 1
		
		if current_successes == required_successes:
			finished()
		else:
			print(current_successes)
			await get_tree().create_timer(0.5).timeout
			start_new_round()
			
	else:
		fail_skill_check()

func fail_skill_check():
	is_active = false
	qte_failed.emit()
	finished()
	
func finished():
	hide()
	current_successes = 0
	qte_finished.emit()
