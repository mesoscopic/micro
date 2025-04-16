extends Enemy

const BULLET = preload("res://scenes/bullets/EnemyBullet.tscn")

func _hurt() -> void:
	super()
	var aim := randf()
	for i in range(0,16):
		var angle = aim+PI/8.*i
		var bullet = BULLET.instantiate()
		bullet.global_position = global_position
		bullet.velocity = Vector2.from_angle(angle) * 75.
		bullet.lifetime = 3.
		bullet.damage = 6
		get_tree().current_scene.get_node("Game/World").call_deferred("add_child", bullet)

func _die() -> void:
	super()
	Micro.world.get_trader(global_position)

func _on_spawn_timer_timeout() -> void:
	var enemy: Enemy = Micro.world.world_enemy(150.)
	enemy.position = position
	add_sibling(enemy)
