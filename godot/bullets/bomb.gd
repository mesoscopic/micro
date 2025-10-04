class_name BombBullet extends Node2D

@export var split_number: int = 8
@export var split_speed: float = 100.
@export var split_damage: int = 20
@export var split_lifetime: float = 2.
@export var origin: Vector2
@export var spin: float = 0.
@export var explosion_damage: int = 30

func _ready() -> void:
	$Rays.set_instance_shader_parameter("rays", split_number)
	$Flash.set_instance_shader_parameter("rays", split_number)
	$Rays.rotation = spin
	$Flash.rotation = spin
	$Bomb.position = origin - global_position
	$Telegraph.rotate(get_angle_to(origin))
	$Bomb.rotate(get_angle_to(origin))
	
	$Bomb/Form.restart()
	get_tree().create_tween().tween_property($Bomb, "instance_shader_parameters/form_anim", 1.0, 0.25)

func fire() -> void:
	var tween := get_tree().create_tween()
	tween.set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_CUBIC).tween_property($Bomb, "position", Vector2.ZERO, 0.25)
	tween.tween_callback(func():
		$Bomb.hide()
		$Telegraph.hide()
		$Rays.hide()
		$Flash.restart()
		$Explosion.restart()
		if global_position.distance_squared_to(Micro.player.position) < 400.:
			Micro.player.damage(explosion_damage, false, Micro.player.get_angle_to(global_position))
		# never would i have come up with making Vector3 the float equivalent of range. like, what?
		for angle in Vector3(PI/float(split_number), 2.*PI, 2.*PI/float(split_number)):
			var bullet: Bullet = preload("res://bullets/EnemyBullet.tscn").instantiate()
			bullet.position = position
			bullet.velocity = Vector2.from_angle(angle+spin) * split_speed
			bullet.damage = split_damage
			bullet.lifetime = split_lifetime
			add_sibling(bullet)
		await Micro.wait(1.)
		queue_free()
	)

func fire_in(time: float) -> void:
	await Micro.wait(time)
	fire()
