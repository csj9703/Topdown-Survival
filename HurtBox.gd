class_name HurtBox
extends Area2D

@export var stun_duration = 1.0  # Duration in seconds the player is stunned

func _init() -> void:
	collision_layer = 0
	collision_mask = 2
	
func _ready() -> void:
	connect("area_entered", self._on_area_entered)

# Owner takes damage if hitbox enters hurtbox area
func _on_area_entered(area: Area2D) -> void:
	if area is HitBox:
		var hitbox = area as HitBox
		if hitbox == null:
			return
		if owner.has_method("take_damage"):
			owner.take_damage(hitbox.damage)
			
		# Stun or immobilize the owner if they have the method
		if owner.has_method("stun"):
			owner.stun(stun_duration)
			
		print('take damage!')
