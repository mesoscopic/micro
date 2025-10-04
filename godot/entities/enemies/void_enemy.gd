extends ChaserEnemy

var prepared_bullets: Array[TelegraphedBullet] = []
var fire := false

func _on_firing_cooldown_timeout() -> void:
	# Only move and attack if the player is out of the world
	if abs(Micro.player.position.x) + abs(Micro.player.position.y) > 10240.:
		speed_multiplier = 1.
	else:
		speed_multiplier = 0.
		return
	if fire:
		for bullet in prepared_bullets:
			bullet.speed = 80.
			bullet.lifetime = 4.
			bullet.damage = 40
			bullet.fire()
		prepared_bullets = []
		fire = false
	else:
		for i in range(0,8):
			var bullet: TelegraphedBullet = preload("res://bullets/HomingBullet.tscn").instantiate()
			bullet.shooter = self
			bullet.angle_offset = i*PI/4
			bullet.aim(get_angle_to(Micro.player.position))
			bullet.distance = 40
			bullet.scale = Vector2(2,2)
			Micro.world.get_node("Bullets").call_deferred("add_child", bullet)
			prepared_bullets.append(bullet)
		fire = true
