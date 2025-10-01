extends CirclerEnemy

func _ready():
	super()

func _on_firing_cooldown_timeout() -> void:
	if !can_see_player() or position.distance_squared_to(Micro.player.position) > 57600:
		$FiringCooldown.start(1.)
		return
	speed_multiplier = 0.
	velocity = Vector2.ZERO
	var bomb: BombBullet = preload("res://bullets/Bomb.tscn").instantiate()
	bomb.position = Micro.player.position
	bomb.split_number = 8
	bomb.origin = position.move_toward(Micro.player.position, 20)
	Micro.world.get_node("Bullets").add_child(bomb)
	bomb.fire_in(1.)
	await Micro.wait(1.)
	speed_multiplier = 1.
	$FiringCooldown.start(2)
