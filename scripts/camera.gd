extends Camera2D

@export var player: Node2D
# Controls how far the camera pulls 
@export var mouse_weight: float = 0.05
# Controls how smoothly the camera glides
@export var smooth_speed: float = 5.0

var MAX_OFFSET_X: float
var MAX_OFFSET_Y: float

func _ready() -> void:
	if player:
		position = player.global_position
	set_max_offset()

func _physics_process(delta):
	if player:
		update_camera_position(delta)
	
func set_max_offset():
	var window_size = get_viewport().size
	MAX_OFFSET_X = window_size.x * 0.2
	MAX_OFFSET_Y = window_size.y * 0.2  

func update_camera_position(delta: float):
	var mouse_offset = player.get_local_mouse_position()
	mouse_offset *= mouse_weight
	mouse_offset.x = clamp(mouse_offset.x, -MAX_OFFSET_X, MAX_OFFSET_X)
	mouse_offset.y = clamp(mouse_offset.y, -MAX_OFFSET_Y, MAX_OFFSET_Y)
	var target_pos = player.position + mouse_offset
	position = position.lerp(target_pos, smooth_speed * delta)
