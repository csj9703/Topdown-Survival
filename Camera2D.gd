extends Camera2D

@export var smooth_speed = 0.1

func cameraUpdate():
	var target_position = get_local_mouse_position()
	position = position.lerp(target_position, smooth_speed)

func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

func _physics_process(_delta):
	if !is_multiplayer_authority():
		return
		
	cameraUpdate()
