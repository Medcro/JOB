extends Node2D

@onready var sanity_bar = $CanvasLayer/SanityBar
@onready var qte: Control = $CanvasLayer/QTE
@onready var qte_timer: Timer = $CanvasLayer/QTE/QTETimer

var sanity : float = 100.0 
var drain_rate : float = 1.0

func _ready():
	MusicManager.play_game()
	qte.hide()
	qte.qte_finished.connect(start_random_timer)
	qte.qte_failed.connect(decrease_sanity)
	start_random_timer()
	sanity_bar.max_value = 100

func _process(delta):
	if sanity > 0:
		sanity -= drain_rate * delta
		sanity_bar.value = sanity
		
func start_random_timer():
	var random_wait = randf_range(5.0, 15.0) 
	qte_timer.wait_time = random_wait
	qte_timer.start()

func _on_qte_timer_timeout() -> void:
	qte.show() 
	qte.start_new_round()
	
func decrease_sanity():
	sanity -= 20
