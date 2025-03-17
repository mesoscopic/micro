extends Ability

func _ready():
	super()
	trigger.connect(start_dash)

func start_dash():
	player.invincible = true
	$DashArea.monitoring = true
	$Duration.start()
	$Cooldown.start()
	$Afterimage.emitting = true
	player.dash_direction = get_local_mouse_position().normalized()
	$Dashline.rotation = player.dash_direction.angle()
	$Dashline.emitting = true

func end_dash(early: bool = false):
	if early: 
		$Duration.stop()
		player._do_ultra($Cooldown.time_left + 0.2)
	player.invincible = false
	$DashArea.monitoring = false
	$Dashline.emitting = false
	$Afterimage.emitting = false
	player.velocity = player.dash_direction * player.max_speed * player.boost_amount
	player.dash_direction = Vector2.ZERO

func _on_dash_cooldown_timeout() -> void:
	$Restore.emitting = true

func _on_dash_area_body_entered(body: Node2D) -> void:
	if body is Damageable:
		body.damage(20)
