extends Enemy

const BULLET = preload("res://scenes/characters/EnemyBullet.tscn")

func _on_firing_cooldown_timeout() -> void:
	for i in range(-1,2):
		var aim = get_angle_to(Micro.player.position) + i*PI/16
		var bullet = BULLET.instantiate()
		bullet.global_position = global_position
		bullet.velocity = Vector2.from_angle(aim) * 80. + velocity/2.
		bullet.lifetime = 3.
		bullet.damage = 10
		get_tree().current_scene.get_node("Game/World").add_child(bullet)
