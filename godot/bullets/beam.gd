class_name BeamBullet extends TelegraphedBullet

@export var max_length: float = 500.

func _ready() -> void:
	form_anim = get_tree().create_tween()
	form_anim.tween_property($Render, "scale", Vector2.ONE, 0.3)
	form_anim.parallel().tween_property($Line, "default_color", Color(1.,1.,1.,.5), 0.3)
	global_position = get_aim_position()
	update_aim()
	$Form.emitting = true
	shooter.die.connect(_on_expire)

func update_aim() -> void:
	rotation = aim_angle
	var space_state = get_world_2d().direct_space_state
	var direction = aim_vec * max_length + global_position
	var query = PhysicsRayQueryParameters2D.create(global_position, direction)
	query.collision_mask = 33
	query.hit_from_inside = true
	var result = space_state.intersect_ray(query)
	if not result:
		$Collision.shape.b = Vector2.RIGHT*max_length
		$Line.points[1] = Vector2.RIGHT*max_length
	else:
		$Collision.shape.b = Vector2.RIGHT*(result.position-global_position).length()
		$Line.points[1] = Vector2.RIGHT*(result.position-global_position).length()

func _physics_process(_delta: float):
	if not shot:
		global_position = get_aim_position()
		update_aim()

func fire() -> void:
	monitorable = true
	shot = true
	get_overlapping_bodies().all(func (body):
		if body is Damageable: body.damage(damage, false, PI-body.get_angle_to(global_position)))
	$Form.emitting = false
	$Form.speed_scale = 4.
	if form_anim.is_running():
		form_anim.kill()
		$Render.scale = Vector2.ONE
	$Line.set("instance_shader_parameters/telegraph", false)
	$Line.default_color = Color.WHITE
	$Render/Front.hide()
	var tween := get_tree().create_tween()
	tween.tween_property($Line, "default_color", Color.TRANSPARENT, 0.1)
	tween.parallel().tween_property($Render/Back, "modulate", Color.TRANSPARENT, 0.1)
	tween.parallel().tween_property($Render/Back, "position", Vector2(-8., 0.), 0.1)
	tween.parallel().tween_property($Shine, "scale", Vector2(60., 60.), 0.1)
	tween.parallel().set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_CUBIC).tween_property($Shine, "modulate", Color.TRANSPARENT, 0.1)
	#$Trail.emitting = true
	if shooter.die.is_connected(_on_expire):
		shooter.die.disconnect(_on_expire)
	await Micro.wait(0.2)
	queue_free()

func _on_expire():
	set_physics_process(false)
	set_deferred("monitorable", false)
	var tween := get_tree().create_tween()
	tween.tween_property($Render/Back, "instance_shader_parameters/dissolve_anim", 1.0, 0.25)
	tween.parallel().tween_property($Render/Front, "instance_shader_parameters/dissolve_anim", 1.0, 0.25)
	tween.parallel().tween_property($Line, "default_color", Color.TRANSPARENT, 0.25)
	tween.tween_callback(queue_free)

func _on_collide(_body) -> void:
	pass
