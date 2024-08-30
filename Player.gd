extends CharacterBody2D

@export var speed = 50.0
@export var interpolation_factor = 0.05
@export var light_duration = 0.11
@export var light_intensity = 1

@onready var gun_light = $MuzzleFlash

var is_reloading = false
var is_shooting = false
var is_aiming = false
var is_meleeing = false
var light_decay_timer = 0.0
var can_move = true

func get_input() -> void:
	if !is_reloading and !is_shooting and !is_aiming and !is_meleeing:
		# Rotate player towards mouse
		var target_direction = get_global_mouse_position() - global_position
		var target_angle = target_direction.angle()
		var current_angle = rotation
		rotation = lerp_angle(current_angle, target_angle, interpolation_factor)

		# Movement based on screen orientation, not player rotation
		var movement_direction = Vector2.ZERO
		
		if Input.is_action_pressed("move_up"):
			movement_direction.y -= 1
		if Input.is_action_pressed("move_down"):
			movement_direction.y += 1
		if Input.is_action_pressed("move_left"):
			movement_direction.x -= 1
		if Input.is_action_pressed("move_right"):
			movement_direction.x += 1
		
		# Normalize movement direction and apply speed
		if movement_direction != Vector2.ZERO:
			movement_direction = movement_direction.normalized() * speed

		velocity = movement_direction
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

# TODO: Change this to use animation tree
func melee() -> void:
	print('meleeing')
	$AnimatedSprite2D.play("melee")
	await $AnimatedSprite2D.animation_finished
	is_meleeing = false

func _physics_process(delta) -> void:
	if can_move:
		get_input()
		move_and_slide()
	# Decay the light over time
	if light_decay_timer > 0:
		light_decay_timer -= delta
		gun_light.energy = max(0, gun_light.energy - delta * light_intensity / light_duration)
	else:
		gun_light.energy = 0.0
	
func _process(_delta) -> void:
	$AnimatedSprite2D.play()

	if Input.is_action_pressed("reload") and not is_reloading:
		is_reloading = true
		await reload()
		
	elif Input.is_action_pressed("shoot") and not is_shooting:
		is_shooting = true
		await shoot()
	
	elif Input.is_action_pressed("melee") and not is_meleeing:
		is_meleeing = true
		await melee()

	if velocity.length() != 0:
		$AnimatedSprite2D.animation = "move"
	elif is_reloading:
		$AnimatedSprite2D.animation = "reload"
	elif is_shooting:
		$AnimatedSprite2D.animation = "shoot"
	elif is_meleeing:
		$AnimatedSprite2D.animation = "melee"
	elif velocity.length() == 0:
		$AnimatedSprite2D.animation = "idle"

# Getters and Setters
func set_can_move(value: bool) -> void:
	can_move = value

func get_is_aiming() -> bool:
	return is_aiming

func get_is_meleeing() -> bool:
	return is_meleeing

func _on_animated_sprite_2d_frame_changed() -> void:
	if $AnimatedSprite2D.animation == "shoot" and $AnimatedSprite2D.frame == 1:
		# Emit light from the gun
		gun_light.energy = light_intensity
		light_decay_timer = light_duration
