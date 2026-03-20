extends Node2D

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

var sanity : float = 100.0 
var drain_rate : float = 1.0

func _ready():
	qte.hide()
	qte.qte_finished.connect(start_random_timer_qte)
	qte.qte_failed.connect(decrease_sanity)
	start_random_timer()
	sanity_bar.max_value = 100
	start_random_timer_qte()

func _process(delta):
	if sanity > 0:
		sanity -= drain_rate * delta
		sanity_bar.value = sanity
		
func start_random_timer_qte():
	var random_wait = randf_range(5.0, 15.0) 
	qte_timer.wait_time = random_wait
	qte_timer.start()

func _on_qte_timer_timeout() -> void:
	qte.show() 
	qte.start_new_round()
	
func start_random_timer():
	var wait_time = randf_range(10.0, 30.0)
	print("start")
	timer.start(wait_time)

func _on_timer_timeout():
	print("timeoutQ")
	change_environment()

func change_environment():
	background.texture = load("res://assets/red/Red-1.png")
	light.texture = load("res://assets/red/AddBelowLight,AboveTable.png")
	person.texture = load("res://assets/red/Red-2.png")
	table.texture = load("res://assets/red/Red-3.png")
	paper_answer.texture = load("res://assets/red/Red-4.png")
	paper_question.texture = load("res://assets/red/Red-5.png")
	lamp.texture = load("res://assets/red/Red-6.png")
	# Or trigger an animation/swap textures here
	print("Environment changed!")
	
func decrease_sanity():
	sanity -= 20
