extends Enemy

const BULLET = preload("res://bullets/TelegraphedBullet.tscn")

var prepared_bullets: Array[TelegraphedBullet] = []

func _ready():
	super()
	aggro.connect(_aggro)
	deaggro.connect(_deaggro)

func _on_firing_cooldown_timeout() -> void:
	for bullet in prepared_bullets:
		bullet.speed = 100.
		bullet.lifetime = 6.
		bullet.damage = 10
		bullet.fire()
	prepared_bullets = []
	for i in range(-1,2):
		var bullet: TelegraphedBullet = BULLET.instantiate()
		bullet.shooter = self
		bullet.angle_offset = i*PI/12
		bullet.aim(get_angle_to(Micro.player.global_position))
		bullet.distance = 25
		Micro.world.get_node("Bullets").add_child(bullet)
		prepared_bullets.append(bullet)

func _physics_process(delta: float) -> void:
	super(delta)
	for bullet in prepared_bullets:
		bullet.aim(get_angle_to(Micro.player.global_position))

func _aggro() -> void:
	$FiringCooldown.start()
	$RetargetTimer.start()
	target_player()

func _deaggro() -> void:
	$FiringCooldown.stop()
	$RetargetTimer.stop()
	wander()
