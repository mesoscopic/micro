extends Enemy

const LASER = preload("res://bullets/Laser.tscn")
var aim := 0.
var aiming := false
var circle_angle := 0.

var laser: LaserBullet

func _ready():
	super()
	aggro.connect(_aggro)
	deaggro.connect(_deaggro)
	tactic_complete.connect(circle)
	die.connect(func (): if laser: laser.stop())

func _physics_process(delta: float) -> void:
	super(delta)
	if aiming:
		aim_laser()

func aim_laser() -> void:
	laser.position = position
	aim = get_angle_to(Micro.player.position)
	laser.rotation = aim
	var space_state = get_world_2d().direct_space_state
	var direction = Vector2.from_angle(aim) * 400. + global_position
	var query = PhysicsRayQueryParameters2D.create(global_position, direction)
	query.collision_mask = 1
	var result = space_state.intersect_ray(query)
	
	if result:
		laser.length = global_position.distance_to(result.position)
	else:
		laser.length = 400.

func _on_firing_cooldown_timeout() -> void:
	if !can_see_player():
		$FiringCooldown.start(1.)
		return
	speed_multiplier = 0.
	laser = LASER.instantiate()
	laser.damage = 25
	laser.lifetime = 1.
	aim_laser()
	Micro.world.get_node("Bullets").add_child(laser)
	aiming = true
	await Micro.wait(0.5)
	aiming = false
	await Micro.wait(0.5)
	laser.fire()
	await Micro.wait(1.)
	speed_multiplier = 1.
	$FiringCooldown.start(1.)

func _aggro() -> void:
	$FiringCooldown.start()
	$RetargetTimer.start()
	circle_angle = get_angle_to(Micro.player.position)
	circle()

func _deaggro() -> void:
	$FiringCooldown.stop()
	$RetargetTimer.stop()
	if laser:
		laser.stop()
		laser = null
	wander()

func circle() -> void:
	circle_angle += PI/8.
	do_tactic(Micro.player.position + Vector2.from_angle(circle_angle)*120.)

func can_see_player() -> bool:
	var query = PhysicsRayQueryParameters2D.create(global_position, Micro.player.position, 1)
	var result = get_world_2d().direct_space_state.intersect_ray(query)
	return result.is_empty()
