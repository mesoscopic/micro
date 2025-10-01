extends CirclerEnemy

func _on_firing_cooldown_timeout() -> void:
	if position.distance_squared_to(Micro.player.position) > 57600 or !can_see_player():
		$FiringCooldown.start(1.)
		return
	var variation = randf_range(-PI/2, PI/2)
	var angle = get_angle_to(Micro.player.position) + variation
	var summon = preload("res://bullets/SpawnerProjectile.tscn").instantiate()
	summon.position = position
	summon.target = global_position + Vector2.from_angle(angle)*100.
	summon.time = 2.-abs(variation)
	summon.spawn = preload("res://entities/enemies/Surprise.tscn")
	Micro.world.get_node("Bullets").add_child(summon)
	$FiringCooldown.start(5.)
