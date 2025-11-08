extends Node2D

func _update_amounts() -> void:
	var spawn_distance: float = ceil(global_position.length() / 20.)
	if spawn_distance < 30.:
		$Spores.emitting = false
	else:
		$Spores.amount_ratio = 0.8**(0.02*(spawn_distance-30))
		$Spores.rotation = get_angle_to(Vector2.ZERO)
		$Spores.emitting = true
	
	$Emptiness.rotation = global_position.angle()
