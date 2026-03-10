extends CirclerEnemy

var aiming := false

var beam: BeamBullet

func _physics_process(delta: float) -> void:
	super(delta)
	if beam and aiming:
		beam.aim(get_angle_to(Micro.player.global_position))

func _on_firing_cooldown_timeout() -> void:
	if !can_see_player() or position.distance_squared_to(Micro.player.position) > 57600:
		$FiringCooldown.start(1.)
		if beam:
			beam._on_expire()
			beam = null
			speed_multiplier = 1.
		return
	if !beam:
		speed_multiplier = 0.
		beam = Micro.new(&"micro:bullet_beam")
		beam.shooter = self
		beam.damage = 25
		beam.distance = 20
		Micro.world.get_node("Bullets").add_child(beam)
		aiming = true
		$FiringCooldown.start(0.5)
	elif aiming:
		aiming = false
		$FiringCooldown.start(0.5)
	else:
		beam.fire()
		speed_multiplier = 1.
		$FiringCooldown.start(1.)
