extends CharacterBody2D

@export var speed = 400.0

func get_input():
	look_at(get_global_mouse_position())
	velocity = transform.x * Input.get_axis("move_down", "move_up") * speed
	
func _physics_process(delta):
	$AnimatedSprite2D.play()
	get_input()
	move_and_slide()
	if $AnimatedSprite2D.animation_finished:
		$AnimatedSprite2D.animation = "idle"
	else:
		if velocity.length() > 0:
			$AnimatedSprite2D.animation = "move"
		elif Input.is_action_pressed("reload"):
			$AnimatedSprite2D.animation = "reload"
		elif Input.is_action_pressed("shoot"):
			$AnimatedSprite2D.animation = "shoot"
