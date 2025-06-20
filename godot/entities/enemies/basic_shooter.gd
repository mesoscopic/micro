extends Enemy

const BULLET = preload("res://bullets/EnemyBullet.tscn")

func _ready():
	super()
	aggro.connect(_aggro)
	deaggro.connect(_deaggro)

func _on_firing_cooldown_timeout() -> void:
	var aim = get_angle_to(Micro.player.position)
	var bullet = BULLET.instantiate()
	bullet.global_position = global_position
	bullet.velocity = Vector2.from_angle(aim) * 90.
	bullet.lifetime = 6.
	bullet.damage = 8
	get_tree().current_scene.get_node("Game/World").add_child(bullet)

func _aggro() -> void:
	$FiringCooldown.start()
	$RetargetTimer.start()
	target_player()

func _deaggro() -> void:
	$FiringCooldown.stop()
	$RetargetTimer.stop()
	wander()
