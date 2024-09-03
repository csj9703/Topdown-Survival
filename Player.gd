extends CharacterBody2D

@export var bullet: PackedScene
@export var speed = 30.0
@export var interpolation_factor = 0.05
@export var light_duration = 0.11
@export var light_intensity = 3

@onready var gun_light = $MuzzleFlash

var bullet_speed = 2000
var is_reloading = false
var is_shooting = false
var is_aiming = false
var is_meleeing = false
var light_decay_timer = 0.0
var can_move = true
var is_stunned = false
var stun_timer = 0.0

func get_input() -> void:
	if !is_stunned and !is_reloading and !is_shooting and !is_aiming and !is_meleeing:
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

func reload() -> void:
	print('reloading')
	$AnimationPlayer.play("reload")
	await $AnimationPlayer.animation_finished
	is_reloading = false

func shoot() -> void:
	print('shooting')
	$AnimationPlayer.play("shoot")
	
	# Check if bullet is a valid PackedScene
	if bullet == null:
		print("Bullet scene is not set")
		return
	
	# Emit light when shooting
	gun_light.energy = light_intensity
	light_decay_timer = light_duration
	
	var bullet_instance = bullet.instantiate()
	# Calculate the bullet's initial position in front of the player
	var bullet_offset = Vector2(30, 0).rotated(rotation)
	bullet_instance.position = global_position + bullet_offset
	bullet_instance.rotation_degrees = rotation_degrees+90
	bullet_instance.linear_velocity = Vector2(bullet_speed, 0).rotated(rotation)
	
	# Add bullet to the scene
	get_tree().get_root().call_deferred('add_child', bullet_instance)
	
	await $AnimationPlayer.animation_finished
	is_shooting = false

func melee() -> void:
	print('meleeing')
	$AnimationPlayer.play("melee")
	await $AnimationPlayer.animation_finished
	is_meleeing = false

func stun(duration: float) -> void:
	is_stunned = true
	stun_timer = duration
	can_move = false

func _physics_process(delta) -> void:
	if can_move:
		get_input()
		move_and_collide(velocity * delta)
	
	if is_stunned:
		stun_timer -= delta
		if stun_timer <= 0:
			is_stunned = false
			can_move = true
		
	# Decay the light over time
	if light_decay_timer > 0:
		light_decay_timer -= delta
		gun_light.energy = max(0, gun_light.energy - delta * light_intensity / light_duration)
	else:
		gun_light.energy = 0.0
	
func _process(_delta) -> void:
	if Input.is_action_pressed("reload") and !is_reloading:
		is_reloading = true
		await reload()
		
	elif Input.is_action_pressed("shoot") and !is_shooting:
		is_shooting = true
		await shoot()
	
	elif Input.is_action_pressed("melee") and !is_meleeing:
		is_meleeing = true
		await melee()

	if velocity.length() != 0:
		$AnimationPlayer.play("move")
	elif is_reloading:
		$AnimationPlayer.play("reload")
	elif is_shooting:
		$AnimationPlayer.play("shoot")
	elif is_meleeing:
		$AnimationPlayer.play("melee")
	elif velocity.length() == 0:
		$AnimationPlayer.play("idle")
			
			
# Getters and Setters
func set_can_move(value: bool) -> void:
	can_move = value

func get_is_aiming() -> bool:
	return is_aiming

func get_is_meleeing() -> bool:
	return is_meleeing
	
func get_is_reloading() -> bool:
	return is_reloading
