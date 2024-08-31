extends Camera2D

@export var smooth_speed = 0.1
func cameraUpdate():
	var pos = get_local_mouse_position()
	if pos.x > get_limit(SIDE_LEFT) and pos.x < get_limit(SIDE_RIGHT):
		pos = lerp(pos, pos, smooth_speed)
		set_position(pos)

func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

func _physics_process(_delta):
	cameraUpdate()
