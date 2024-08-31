extends CharacterBody2D

@export var rotation_speed = 0.015
@export var move_speed = 15.0

@onready var player = get_parent().get_node("Player")

var is_attacking = false
var can_move = false

func _physics_process(_delta: float) -> void:
	if can_move:
		var to_player = player.global_position - global_position
		var target_rotation = to_player.angle()
		# Smoothes the zombie rotation just like the player
		rotation = lerp_angle(rotation, target_rotation, rotation_speed)
		
		# Move the zombie towards the player
		var direction = Vector2(cos(rotation), sin(rotation)).normalized()
		velocity = direction * move_speed
		move_and_slide()

func _process(_delta) -> void:
	if velocity.length() != 0 and not is_attacking:
		$AnimationPlayer.play("move")
	elif velocity.length() == 0 and not is_attacking:
		$AnimationPlayer.play("idle")

func stop_and_attack() -> void:
	can_move = false
	is_attacking = true
	$AnimationPlayer.play('attack')
	await $AnimationPlayer.animation_finished
	is_attacking = false
	can_move = true
