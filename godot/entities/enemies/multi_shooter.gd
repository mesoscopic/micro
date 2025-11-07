extends ChaserEnemy

const BULLET = preload("res://bullets/TelegraphedBullet.tscn")

var prepared_bullets: Array[TelegraphedBullet] = []

func _ready():
	super()

func _on_firing_cooldown_timeout() -> void:
	if position.distance_squared_to(Micro.player.position) > 57600: return
	for bullet in prepared_bullets:
		bullet.speed = 150.
		bullet.lifetime = 6.
		bullet.damage = 10
		bullet.fire()
	prepared_bullets = []
	for i in range(-1,2):
		var bullet: TelegraphedBullet = BULLET.instantiate()
		bullet.shooter = self
		bullet.angle_offset = i*PI/8
		bullet.aim(get_angle_to(Micro.player.global_position))
		bullet.distance = 25
		Micro.world.get_node("Bullets").add_child(bullet)
		prepared_bullets.append(bullet)

func _physics_process(delta: float) -> void:
	super(delta)
	for bullet in prepared_bullets:
		bullet.aim(get_angle_to(Micro.player.global_position))
