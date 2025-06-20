extends Enemy

const BULLET = preload("res://bullets/EnemyBullet.tscn")
var aim := 0.
var aiming := false
var circle_angle := 0.

func _ready():
	super()
	aggro.connect(_aggro)
	deaggro.connect(_deaggro)
	tactic_complete.connect(circle)

func _physics_process(delta: float) -> void:
	super(delta)
	if aiming:
		aim = get_angle_to(Micro.player.position)
		$Telegraph.set_point_position(1, Vector2.from_angle(aim)*400.)

func _on_firing_cooldown_timeout() -> void:
	if !can_see_player():
		$FiringCooldown.start(1.)
		return
	speed_multiplier = 0.
	aim = get_angle_to(Micro.player.position)
	$Telegraph.set_point_position(1, Vector2.from_angle(aim)*400.)
	$Telegraph.set_instance_shader_parameter("disappear", 0.)
	$Telegraph.show()
	aiming = true
	await Micro.wait(0.5)
	aiming = false
	await Micro.wait(0.5)
	var tween = create_tween().set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT).tween_property($Telegraph, "instance_shader_parameters/disappear", 1., 1.)
	tween.finished.connect(func (): $Telegraph.hide())
	for i in range(0,10):
		var bullet = BULLET.instantiate()
		bullet.global_position = global_position
		bullet.velocity = Vector2.from_angle(aim) * 300.
		bullet.lifetime = 3.
		bullet.damage = 8
		bullet.scale = Vector2(1.5, 1.5)
		get_tree().current_scene.get_node("Game/World").add_child(bullet)
		await Micro.wait(0.05)
	speed_multiplier = 1.
	$FiringCooldown.start(2.)

func _aggro() -> void:
	$FiringCooldown.start()
	$RetargetTimer.start()
	circle_angle = get_angle_to(Micro.player.position)
	circle()

func _deaggro() -> void:
	$FiringCooldown.stop()
	$RetargetTimer.stop()
	wander()

func circle() -> void:
	circle_angle += PI/8.
	do_tactic(Micro.player.position + Vector2.from_angle(circle_angle)*120.)

func can_see_player() -> bool:
	var query = PhysicsRayQueryParameters2D.create(global_position, Micro.player.position, 1)
	var result = get_world_2d().direct_space_state.intersect_ray(query)
	return result.is_empty()
