extends Node2D

@export var initial_ring_size = 1.5
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
	# prevents player from meleeing and aiming, meleeing resets the accuracy
	if Input.is_action_pressed("aim") and not player.get_is_aiming() and not player.get_is_meleeing() and not player.get_is_reloading():
		player.set_can_move(false)
		current_ring_size = max(0.25, current_ring_size - ring_shrink_rate * delta)
		ring.set_scale(Vector2.ONE * current_ring_size)
	else:
		player.set_can_move(true)
		current_ring_size = initial_ring_size
		ring.set_scale(Vector2.ONE * current_ring_size)
		
