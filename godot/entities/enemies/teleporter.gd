extends Enemy

const BULLET = preload("res://bullets/EnemyBullet.tscn")

func _ready():
	super()
	aggro.connect(_aggro)
	deaggro.connect(_deaggro)

func _on_firing_cooldown_timeout() -> void:
	for i in range(-2,3):
		var aim = get_angle_to(Micro.player.position) + i*PI/9
		var bullet = BULLET.instantiate()
		bullet.global_position = global_position
		bullet.velocity = Vector2.from_angle(aim) * 100.
		bullet.lifetime = 3.
		bullet.damage = 10
		get_tree().current_scene.get_node("Game/World").add_child(bullet)
	$FiringCooldown.start(1.2)

func _aggro() -> void:
	$FiringCooldown.start()
	$RetargetTimer.start()
	target_player()

func _deaggro() -> void:
	$FiringCooldown.stop()
	$RetargetTimer.stop()
	wander()

func _hurt(amount: int) -> void:
	invincible = true
	super(amount)
	$FiringCooldown.start(3.)
	await Micro.wait(0.25)
	invincible = false
	global_position = Micro.player.position + Vector2.from_angle(randf_range(0, 2*PI))*randf_range(100.,200.)
	while !can_teleport_to(global_position):
		global_position = Micro.player.position + Vector2.from_angle(randf_range(0, 2*PI))*randf_range(100.,200.)
	for i in range(0,12):
		var angle = PI/6.*i
		var bullet = BULLET.instantiate()
		bullet.global_position = global_position
		bullet.velocity = Vector2.from_angle(angle) * 100.
		bullet.lifetime = 3.
		bullet.damage = 7.
		bullet.scale = Vector2(0.8,0.8)
		get_tree().current_scene.get_node("Game/World").add_child(bullet)

func can_teleport_to(location: Vector2) -> bool:
	var query = PhysicsShapeQueryParameters2D.new()
	var transformation = global_transform
	transformation.origin = location
	query.set_transform(global_transform)
	query.set_shape($CollisionShape2D.shape)
	var space_state = get_world_2d().get_direct_space_state()
	var result = space_state.get_rest_info(query)
	return result.is_empty()
