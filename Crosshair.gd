extends Node2D

@export var initial_ring_size = 0.75
@export var ring_shrink_rate = 0.5

@onready var ring = $Ring
@onready var dot = $Dot
@onready var player = get_parent().get_node("Player")

var current_ring_size = initial_ring_size

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	ring.set_scale(Vector2.ONE * initial_ring_size)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	global_position = get_global_mouse_position()
	if Input.is_action_pressed("aim") and not player.get_is_aiming():
		#player.set_is_aiming(true)
		current_ring_size = max(0.25, current_ring_size - ring_shrink_rate * delta)
		ring.set_scale(Vector2.ONE * current_ring_size)
	else:
		#player.set_is_aiming(false)
		current_ring_size = initial_ring_size
		ring.set_scale(Vector2.ONE * current_ring_size)
		
