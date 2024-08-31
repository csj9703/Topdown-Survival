class_name HurtBox
extends Area2D

func _init() -> void:
	collision_layer = 0
	collision_mask = 2
	
func _ready() -> void:
	connect("area_entered", self._on_area_entered)

# Owner takes damage if hitbox enters hurtbox area
func _on_area_entered(area: Area2D) -> void:
	if  area is HitBox:
		var hitbox = area as HitBox
		if hitbox == null:
			return
		if owner.has_method("take_damage"):
			owner.take_damage(hitbox.damage)
		print('take damage!')
