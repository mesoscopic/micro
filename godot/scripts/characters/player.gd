extends CharacterBody2D

const BULLET = preload("res://scenes/characters/PlayerBullet.tscn")

const max_speed = 60;
const acceleration = 300;
const deceleration = 400;
const shoot_cooldown = 0.5;

func _physics_process(delta):
	var direction = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	$AimMarker.global_position = get_aim_position()
	$AimMarker.emitting = $ShootCooldown.is_stopped()
	if direction != Vector2.ZERO:
		velocity = velocity.move_toward(direction * max_speed, acceleration * delta)
	else:
		velocity = velocity.move_toward(Vector2.ZERO, deceleration * delta)
		
	$Character/Render.material.set("shader_parameter/velocity", velocity / max_speed)
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

func get_aim_position():
	var space_state = get_world_2d().direct_space_state
	var direction = get_local_mouse_position().normalized() * 40 + global_position
	var query = PhysicsRayQueryParameters2D.create(global_position, direction)
	query.exclude = [self]
	var result = space_state.intersect_ray(query)
	
	if result:
		return result.position
	else:
		return direction
