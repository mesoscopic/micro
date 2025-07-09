class_name BombBullet extends TelegraphedBullet

var split_number: int = 8
var split_speed: float = 100.
var split_lifetime: float = 3.
var split_damage: int = 10
var split_scale: float = 1.

func _on_collide(body) -> void:
	_on_expire()
	$Impact.emitting = true
	
	if body is Damageable:
		body.damage(damage)
	else:
		for i in range(0,split_number):
			var angle = 2*PI/split_number*i
			var bullet = preload("res://bullets/EnemyBullet.tscn").instantiate()
			bullet.global_position = global_position
			bullet.velocity = Vector2.from_angle(angle) * split_speed
			bullet.lifetime = split_lifetime
			bullet.damage = split_damage
			bullet.scale = Vector2(split_scale,split_scale)
			Micro.world.get_node("Bullets").call_deferred("add_child", bullet)
