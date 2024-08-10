extends CharacterBody2D

@export var speed = 100.0
@export var interpolation_factor = 0.05
var is_reloading = false
var is_shooting = false

func get_input():
	if !is_reloading and !is_shooting:
		var target_direction = get_viewport().get_mouse_position() - global_position
		var target_angle = target_direction.angle()
		var current_angle = rotation
		rotation = lerp_angle(current_angle, target_angle, interpolation_factor) # Smooth the player rotation to increse difficulty
		velocity = transform.x * Input.get_axis("move_down", "move_up") * speed
	else:
		velocity = Vector2.ZERO

# TODO: Change this to use animation tree
func reload() -> void:
	print('reloading')
	$AnimationPlayer.play("reload")
	await $AnimationPlayer.animation_finished
	is_reloading = false
	
# TODO: Change this to use animation tree
func shoot() -> void:
	print('shooting')
	$AnimationPlayer.play("shoot")
	await $AnimationPlayer.animation_finished
	is_shooting = false
	
func _physics_process(_delta):
	get_input()
	move_and_slide()
	
func _process(_delta):
	$AnimatedSprite2D.play()
	
	if Input.is_action_pressed("reload") and not is_reloading:
		is_reloading = true
		await reload()
		
	elif Input.is_action_pressed("shoot") and not is_shooting:
		is_shooting = true
		await shoot()
		
	if velocity.length() != 0:
		$AnimatedSprite2D.animation = "move"
	elif is_reloading:
		$AnimatedSprite2D.animation = "reload"
	elif is_shooting:
		$AnimatedSprite2D.animation = "shoot"
	elif velocity.length() == 0:
		$AnimatedSprite2D.animation = "idle"
