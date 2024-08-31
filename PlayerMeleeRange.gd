class_name PlayerMeleeRange
extends Area2D

func _init() -> void:
	collision_layer = 0
	collision_mask = 3
	
func _ready() -> void:
	connect("area_entered", self._on_area_entered)

# Player entering the zombies' melee range
func _on_area_entered(area: Area2D) -> void:
	if  area is ZombieMeleeRange:
		var zmr = area as ZombieMeleeRange
		if zmr == null:
			return
		print('Zombie attacking!')
		zmr.get_owner().stop_and_attack()
