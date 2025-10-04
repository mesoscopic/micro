extends CirclerEnemy

var prepared_bullet: TelegraphedBullet

func _physics_process(delta: float) -> void:
	super(delta)
	if prepared_bullet:
		prepared_bullet.aim(get_angle_to(Micro.player.global_position))

func _on_firing_cooldown_timeout() -> void:
	if position.distance_squared_to(Micro.player.position) > 57600: return
	if prepared_bullet:
		prepared_bullet.speed = 100.
		prepared_bullet.lifetime = 5.
		prepared_bullet.damage = 20
		prepared_bullet.fire()
		prepared_bullet = null
		speed_multiplier = 0.3
	else:
		prepared_bullet = preload("res://bullets/TelegraphedBullet.tscn").instantiate()
		prepared_bullet.shooter = self
		prepared_bullet.aim(get_angle_to(Micro.player.global_position))
		prepared_bullet.distance = 20
		Micro.world.get_node("Bullets").add_child(prepared_bullet)
		speed_multiplier = 1.
