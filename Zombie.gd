extends CharacterBody2D

@export var rotation_speed = 0.015
@export var move_speed = 25.0

@onready var player = get_parent().get_node("Player")

func _physics_process(delta: float) -> void:
	var to_player = player.global_position - global_position
	var target_rotation = to_player.angle()
	# Smoothes the zombie rotation just like the player
	rotation = lerp_angle(rotation, target_rotation, rotation_speed)
	
	# Move the zombie towards the player
	var direction = Vector2(cos(rotation), sin(rotation)).normalized()
	velocity = direction * move_speed
	move_and_slide()
