extends CharacterBody2D

const BULLET = preload("res://scenes/characters/PlayerBullet.tscn")

const max_speed = 60;
const acceleration = 300;
const deceleration = 400;
const shoot_cooldown = 0.5;

var dash_direction := Vector2.ZERO;

func _physics_process(delta):
	var direction = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	$AimMarker.global_position = get_aim_position()
	$AimMarker.emitting = $ShootCooldown.is_stopped()
	if dash_direction != Vector2.ZERO:
		velocity = dash_direction * max_speed * 10
	else:
		if direction != Vector2.ZERO:
			velocity = velocity.move_toward(direction * max_speed, acceleration * delta)
		else:
			velocity = velocity.move_toward(Vector2.ZERO, deceleration * delta)
		
	$Character/Render.material.set("shader_parameter/velocity", (velocity / max_speed) if (dash_direction == Vector2.ZERO) else dash_direction)
	$Character/Render.material.set("shader_parameter/can_dash", $DashCooldown.is_stopped())
	move_and_slide()
	
	if Input.is_action_pressed("shoot"):
		if $ShootCooldown.time_left > 0: return
		for i in range(0,1):
			var aim = get_local_mouse_position().angle() + i*PI/16
			var bullet = BULLET.instantiate()
			bullet.global_position = get_aim_position()
			bullet.velocity = Vector2.from_angle(aim) * 80. + velocity/2.
			bullet.lifetime = 3.
			get_tree().current_scene.get_node("Game/World").add_child(bullet)
		$ShootCooldown.start(shoot_cooldown)
	
	if Input.is_action_just_pressed("dash") and $DashCooldown.is_stopped():
		start_dash()

func get_aim_position() -> Vector2:
	var space_state = get_world_2d().direct_space_state
	var direction = get_local_mouse_position().normalized() * 40 + global_position
	var query = PhysicsRayQueryParameters2D.create(global_position, direction)
	query.exclude = [self]
	var result = space_state.intersect_ray(query)
	
	if result:
		return result.position
	else:
		return direction

func start_dash():
	$DashDuration.start()
	$DashCooldown.start()
	$Afterimage.emitting = true
	dash_direction = get_local_mouse_position().normalized()
	$Dashline.rotation = dash_direction.angle()
	$Dashline.emitting = true

func end_dash():
	$Afterimage.emitting = false
	$Dashline.emitting = false
	velocity = dash_direction * max_speed
	dash_direction = Vector2.ZERO

func _on_dash_cooldown_timeout() -> void:
	$Restore.emitting = true
