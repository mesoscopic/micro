extends CirclerEnemy

const LASER = preload("res://bullets/Laser.tscn")
var aim := 0.
var aiming := false

var laser: LaserBullet

func _ready():
	super()
	die.connect(func (): if laser: laser.stop())

func _physics_process(delta: float) -> void:
	super(delta)
	if aiming and laser:
		aim_laser()

func aim_laser() -> void:
	laser.position = position
	aim = get_angle_to(Micro.player.position)
	laser.rotation = aim
	var space_state = get_world_2d().direct_space_state
	var direction = Vector2.from_angle(aim) * 400. + global_position
	var query = PhysicsRayQueryParameters2D.create(global_position, direction)
	query.collision_mask = 17
	query.exclude = [Micro.player]
	var result = space_state.intersect_ray(query)
	
	if result:
		laser.length = global_position.distance_to(result.position)
	else:
		laser.length = 400.

func _on_firing_cooldown_timeout() -> void:
	if !can_see_player() or position.distance_squared_to(Micro.player.position) > 57600:
		$FiringCooldown.start(1.)
		return
	speed_multiplier = 0.
	laser = LASER.instantiate()
	laser.damage = 20
	laser.lifetime = 1.
	aim_laser()
	Micro.world.get_node("Bullets").add_child(laser)
	aiming = true
	await Micro.wait(0.5)
	aiming = false
	await Micro.wait(0.5)
	laser.fire(.5)
	await Micro.wait(1.)
	speed_multiplier = 1.
	$FiringCooldown.start(1.)

func can_see_player() -> bool:
	var query = PhysicsRayQueryParameters2D.create(global_position, Micro.player.position, 17, [Micro.player])
	var result = get_world_2d().direct_space_state.intersect_ray(query)
	return result.is_empty()
