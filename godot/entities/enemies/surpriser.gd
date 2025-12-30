extends CirclerEnemy

func _on_firing_cooldown_timeout() -> void:
	if position.distance_squared_to(Micro.player.position) > 57600 or !can_see_player():
		$FiringCooldown.start(1.)
		return
	var target = global_position+Vector2.from_angle(get_angle_to(Micro.player.position) + randf_range(-PI/2, PI/2))*100.
	while !Micro.world.can_enemy_fit(target, 10):
		target = global_position+Vector2.from_angle(get_angle_to(Micro.player.position) + randf_range(-PI/2, PI/2))*100.
	var summon = Micro.new(&"micro:bullet_spawner")
	summon.position = position
	summon.target = target
	summon.time = 2.
	summon.spawn = &"micro:enemy_surprise"
	Micro.world.get_node("Bullets").add_child(summon)
	$FiringCooldown.start(5.)
	invincible = true
	speed_multiplier = 0
	$EnemyTeleport.restart()
	await Micro.wait(0.5)
	invincible = false
	speed_multiplier = 1
	global_position = Micro.player.position + Vector2.from_angle(randf_range(0, 2*PI))*randf_range(100.,200.)
	while !Micro.world.can_enemy_fit(global_position, $CollisionShape2D.shape.radius):
		global_position = Micro.player.position + Vector2.from_angle(randf_range(0, 2*PI))*randf_range(100.,200.)
