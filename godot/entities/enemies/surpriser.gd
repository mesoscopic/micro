extends CirclerEnemy

var aim := 0.
var aiming := false

func _ready():
	super()

func _physics_process(delta: float) -> void:
	super(delta)
	if aiming:
		aim = get_angle_to(Micro.player.position)
		$Telegraph.set_point_position(1, Vector2.from_angle(aim)*400.)

func _on_firing_cooldown_timeout() -> void:
	if position.distance_squared_to(Micro.player.position) > 57600: $FiringCooldown.start(1.)
	var variation = randf_range(-PI/2, PI/2)
	var angle = get_angle_to(Micro.player.position) + variation
	var summon = preload("res://bullets/SpawnerProjectile.tscn").instantiate()
	summon.position = position
	summon.target = global_position + Vector2.from_angle(angle)*100.
	summon.time = 2.-abs(variation)
	summon.spawn = preload("res://entities/enemies/Surprise.tscn")
	Micro.world.get_node("Bullets").add_child(summon)
	$FiringCooldown.start(5.)

func can_see_player() -> bool:
	var query = PhysicsRayQueryParameters2D.create(global_position, Micro.player.position, 1)
	var result = get_world_2d().direct_space_state.intersect_ray(query)
	return result.is_empty()
