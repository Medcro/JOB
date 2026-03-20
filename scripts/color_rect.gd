extends ColorRect

var vignette_material : ShaderMaterial
@onready var clickable: Clickable = $"../../Environment/PaperQuestion/Clickable"
@onready var clickable2: Clickable = $"../../Environment/PaperAnswer/Clickable2"

var pulse_tween: Tween

func _ready() -> void:
	vignette_material = self.material as ShaderMaterial
	clickable.timer_timeout.connect(_on_timeout)
	clickable2.timer_timeout.connect(_on_timeout)
	clickable.paper_closed.connect(stop_pulse)
	clickable2.paper_closed.connect(stop_pulse)

func _on_timeout():
	if pulse_tween and pulse_tween.is_valid():
		pulse_tween.kill()
	pulse_tween = create_tween().set_loops() 
	
	pulse_tween.tween_method(set_vignette_alpha, 0.6, 0.8, 1.0).set_trans(Tween.TRANS_SINE)
	pulse_tween.tween_method(set_vignette_alpha, 0.8, 0.6, 1.0).set_trans(Tween.TRANS_SINE)

func stop_pulse():
	if pulse_tween and pulse_tween.is_valid():
		pulse_tween.kill() 
	set_vignette_alpha(0.0) 

func set_vignette_alpha(value: float):
	vignette_material.set_shader_parameter("MainAlpha", value)
