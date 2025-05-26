extends Enemy

const BULLET = preload("res://scenes/bullets/EnemyBullet.tscn")

func _ready():
	super()
	aggro.connect(_aggro)
	deaggro.connect(_deaggro)

func _on_firing_cooldown_timeout() -> void:
	for i in range(-1,2):
		var aim = get_angle_to(Micro.player.position) + i*PI/12
		var bullet = BULLET.instantiate()
		bullet.global_position = global_position
		bullet.velocity = Vector2.from_angle(aim) * 100.
		bullet.lifetime = 6.
		bullet.damage = 10
		get_tree().current_scene.get_node("Game/World").add_child(bullet)

func _aggro() -> void:
	$FiringCooldown.start()
	$RetargetTimer.start()
	target_player()

func _deaggro() -> void:
	$FiringCooldown.stop()
	$RetargetTimer.stop()
	wander()
