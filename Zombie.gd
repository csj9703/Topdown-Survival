extends CharacterBody2D

@export var rotation_speed = 0.015
@export var move_speed = 15.0
@export var attack_interval = 1.0

@onready var player = get_parent().get_node("Player")

var is_attacking = false
var can_move = true
var attack_timer = 1.0
var is_player_in_range = false

func _physics_process(_delta: float) -> void:
	if can_move:
		var to_player = player.global_position - global_position
		var target_rotation = to_player.angle()
		rotation = lerp_angle(rotation, target_rotation, rotation_speed)
		
		var direction = Vector2(cos(rotation), sin(rotation)).normalized()
		velocity = direction * move_speed
		move_and_collide(velocity * _delta)

	if is_attacking:
		attack_timer -= _delta
		if attack_timer <= 0.0 and is_player_in_range:
			perform_attack()

func _process(_delta) -> void:
	if velocity.length() != 0 and not is_attacking:
		$AnimationPlayer.play("move")
	elif velocity.length() == 0 and not is_attacking:
		$AnimationPlayer.play("idle")

func start_attacking() -> void:
	if not is_attacking:
		can_move = false
		is_attacking = true
		attack_timer = 0.0
		perform_attack()

func stop_attacking() -> void:
	is_player_in_range = false

func perform_attack() -> void:
	$AnimationPlayer.play('attack')
	attack_timer = attack_interval
	await $AnimationPlayer.animation_finished
	
	# Check if the player is still in range to continue attacking
	if is_player_in_range:
		attack_timer = attack_interval
	else:
		is_attacking = false
		can_move = true
