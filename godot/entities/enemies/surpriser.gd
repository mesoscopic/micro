extends Enemy

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
	var variation = randf_range(-PI/2, PI/2)
	var angle = get_angle_to(Micro.player.position) + variation
	var summon = preload("res://bullets/SpawnerProjectile.tscn").instantiate()
	summon.position = position
	summon.target = global_position + Vector2.from_angle(angle)*100.
	summon.time = 2.-abs(variation)
	summon.spawn = preload("res://entities/enemies/Surprise.tscn")
	add_sibling(summon)

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
