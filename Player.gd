extends CharacterBody2D

@export var speed = 50.0
@export var interpolation_factor = 0.05
var is_reloading = false
var is_shooting = false

var light_decay_timer = 0.0
@export var light_duration = 0.11
@export var light_intensity = 1

# Reference to the Light2D node
@onready var gun_light = $MuzzleFlash

func get_input():
	if !is_reloading and !is_shooting:
		var target_direction = get_global_mouse_position() - global_position
		var target_angle = target_direction.angle()
		var current_angle = rotation
		rotation = lerp_angle(current_angle, target_angle, interpolation_factor) # Smooth the player rotation to increase difficulty

		# Forward (toward the mouse) and backward (away from the mouse) movement
		var forward_input = Input.get_axis("move_down", "move_up")
		var forward_direction = transform.x * forward_input

		# Side (left/right) movement relative to the player's current direction
		var side_input = Input.get_axis("move_left", "move_right")
		var side_direction = Vector2(-transform.x.y, transform.x.x) * side_input # Perpendicular vector to the forward direction

		# Combine the forward/backward and side movements
		var movement_direction = forward_direction + side_direction

		# Calculate the velocity based on the movement direction and speed
		velocity = movement_direction.normalized() * speed if movement_direction != Vector2.ZERO else Vector2.ZERO
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
	$AnimatedSprite2D.play("shoot")
	await $AnimatedSprite2D.animation_finished
	is_shooting = false
	
func _physics_process(delta):
	get_input()
	move_and_slide()
	# Decay the light over time
	if light_decay_timer > 0:
		light_decay_timer -= delta
		gun_light.energy = max(0, gun_light.energy - delta * light_intensity / light_duration)
	else:
		gun_light.energy = 0.0
	
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

func _on_animated_sprite_2d_frame_changed():
	if $AnimatedSprite2D.animation == "shoot" and $AnimatedSprite2D.frame == 1: # Frame index starts from 0
		# Emit light from the gun
		gun_light.energy = light_intensity
		light_decay_timer = light_duration
