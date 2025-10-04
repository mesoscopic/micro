extends ChaserEnemy

const BULLET = preload("res://bullets/TelegraphedBullet.tscn")

var prepared_bullets: Array[TelegraphedBullet] = []

func _ready():
	super()

func _on_firing_cooldown_timeout() -> void:
	if position.distance_squared_to(Micro.player.position) > 57600:
		$FiringCooldown.start(1.)
		return
	for bullet in prepared_bullets:
		bullet.speed = 100.
		bullet.lifetime = 3.
		bullet.damage = 20
		bullet.fire()
	prepared_bullets = []
	for i in range(-2,3):
		var bullet: TelegraphedBullet = BULLET.instantiate()
		bullet.shooter = self
		bullet.angle_offset = i*PI/9
		bullet.aim(get_angle_to(Micro.player.global_position))
		bullet.distance = 20
		Micro.world.get_node("Bullets").add_child(bullet)
		prepared_bullets.append(bullet)
	$FiringCooldown.start(1.2)

func _hurt(amount: int, direction: float) -> void:
	invincible = true
	super(amount, direction)
	$EnemyTeleport.restart()
	for bullet in prepared_bullets:
		bullet._on_expire()
	prepared_bullets = []
	$FiringCooldown.start(2.)
	await Micro.wait(0.25)
	invincible = false
	global_position = Micro.player.position + Vector2.from_angle(randf_range(0, 2*PI))*randf_range(100.,200.)
	while !can_teleport_to(global_position):
		global_position = Micro.player.position + Vector2.from_angle(randf_range(0, 2*PI))*randf_range(100.,200.)
	for i in range(0,12):
		var angle = PI/6.*i
		var bullet = preload("res://bullets/EnemyBullet.tscn").instantiate()
		bullet.global_position = global_position
		bullet.velocity = Vector2.from_angle(angle) * 100.
		bullet.lifetime = 3.
		bullet.damage = 15
		bullet.scale = Vector2(0.8,0.8)
		Micro.world.get_node("Bullets").add_child(bullet)

func can_teleport_to(location: Vector2) -> bool:
	var query = PhysicsShapeQueryParameters2D.new()
	var transformation = global_transform
	transformation.origin = location
	query.set_transform(global_transform)
	query.set_shape($CollisionShape2D.shape)
	var space_state = get_world_2d().get_direct_space_state()
	var result = space_state.get_rest_info(query)
	return result.is_empty()

func _physics_process(delta: float) -> void:
	super(delta)
	for bullet in prepared_bullets:
		bullet.aim(get_angle_to(Micro.player.global_position))
