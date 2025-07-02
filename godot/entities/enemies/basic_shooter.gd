extends Enemy

const BULLET = preload("res://bullets/TelegraphedBullet.tscn")

var prepared_bullet: TelegraphedBullet

func _ready():
	super()
	aggro.connect(_aggro)
	deaggro.connect(_deaggro)

func _on_firing_cooldown_timeout() -> void:
	if prepared_bullet:
		prepared_bullet.speed = 90.
		prepared_bullet.lifetime = 6.
		prepared_bullet.damage = 8
		prepared_bullet.fire()
	
	var bullet: TelegraphedBullet = BULLET.instantiate()
	bullet.shooter = self
	bullet.aim(get_angle_to(Micro.player.global_position))
	bullet.distance = 20
	Micro.world.get_node("Entities").add_child(bullet)
	prepared_bullet = bullet

func _aggro() -> void:
	$FiringCooldown.start()
	$RetargetTimer.start()
	target_player()

func _deaggro() -> void:
	$FiringCooldown.stop()
	$RetargetTimer.stop()
	wander()
