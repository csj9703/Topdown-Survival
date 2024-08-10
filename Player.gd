extends CharacterBody2D

@export var speed = 400.0
var is_reloading = false
var is_shooting = false

func get_input():
	if !is_reloading and !is_shooting:
		look_at(get_global_mouse_position())
		velocity = transform.x * Input.get_axis("move_down", "move_up") * speed
	else:
		velocity = Vector2.ZERO

func reload() -> void:
	print('reloading')
	$AnimationPlayer.play("reload")
	await $AnimationPlayer.animation_finished
	is_reloading = false

func shoot():
	print('shooting')
	# TODO Additional shooting logic here
	
func _physics_process(delta):
	get_input()
	move_and_slide()
	
func _process(delta):
	$AnimatedSprite2D.play()
	
	if Input.is_action_pressed("reload") and not is_reloading:
		is_reloading = true
		await reload()
		
	elif Input.is_action_pressed("shoot") and not is_shooting:
		is_shooting = true
		shoot()
		is_shooting = false
		
	if velocity.length() != 0:
		$AnimatedSprite2D.animation = "move"
	elif is_reloading:
		$AnimatedSprite2D.animation = "reload"
	elif is_shooting:
		$AnimatedSprite2D.animation = "shoot"
	elif velocity.length() == 0:
		$AnimatedSprite2D.animation = "idle"
