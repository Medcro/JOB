extends TextureProgressBar

var drain_rate_per_second : float = 1.0

func _ready():
	max_value = 100
	value = 100

func _process(delta):
	if value > 0:
		value -= drain_rate_per_second * delta
