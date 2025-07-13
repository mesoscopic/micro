extends ChaserEnemy

const BULLET = preload("res://bullets/TelegraphedBullet.tscn")

var prepared_bullet: TelegraphedBullet

func _ready():
	super()

func _on_firing_cooldown_timeout() -> void:
	if position.distance_squared_to(Micro.player.position) > 57600: return
	if prepared_bullet:
		prepared_bullet.speed = 90.
		prepared_bullet.lifetime = 6.
		prepared_bullet.damage = 8
		prepared_bullet.fire()
	
	var bullet: TelegraphedBullet = BULLET.instantiate()
	bullet.shooter = self
	bullet.aim(get_angle_to(Micro.player.global_position))
	bullet.distance = 20
	Micro.world.get_node("Bullets").add_child(bullet)
	prepared_bullet = bullet
