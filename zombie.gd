extends CharacterBody2D

@onready var vision_collision = $Vision/VisionCollision
@onready var navigation_agent_2d: NavigationAgent2D = $NavigationAgent2D

const SPEED = 10.0
const ROTATION_SPEED = 2.0
const STOP_DISTANCE = 20.0

var target: Node2D = null

func _physics_process(delta: float) -> void:
	if is_instance_valid(target):
		var direction = global_position.direction_to(target.global_position)

		var target_angle = direction.angle() + -PI / 2
		rotation = rotate_toward(rotation, target_angle, ROTATION_SPEED * delta)

		if global_position.distance_to(target.global_position) > STOP_DISTANCE:
			velocity = direction * SPEED
		else:
			velocity = Vector2.ZERO
	else:
		target = null
		velocity = Vector2.ZERO

	move_and_slide()


func _on_vision_body_entered(body: Node2D) -> void:
	if body.is_in_group("players") and target == null:
		print("Player detected!")

		target = body
		vision_collision.change_color(Color(1, 0, 0, 0.3))


func _on_vision_body_exited(body: Node2D) -> void:
	if body == target:
		print("Player left vision, continuing chase!")
