extends ChaserEnemy

var round_1: Array[TelegraphedBullet] = []
var round_2: Array[TelegraphedBullet] = []

func _on_firing_cooldown_timeout() -> void:
	if abs(Micro.player.position.x) + abs(Micro.player.position.y) > 5120.:
		speed_multiplier = 1.
	else:
		speed_multiplier = 0.5
	for bullet in round_1:
		bullet.speed = 80.
		bullet.lifetime = 4.
		bullet.damage = 30
		bullet.fire()
	round_1 = round_2
	round_2 = []
	var r := Micro.world.random.randf_range(0., 2.*PI)
	for i in range(0,4):
		var bullet: TelegraphedBullet = preload("res://bullets/TelegraphedBullet.tscn").instantiate()
		bullet.shooter = self
		bullet.angle_offset = r + i*PI/2
		bullet.aim(get_angle_to(Micro.player.position))
		bullet.distance = 30
		Micro.world.get_node("Bullets").call_deferred("add_child", bullet)
		round_2.append(bullet)
