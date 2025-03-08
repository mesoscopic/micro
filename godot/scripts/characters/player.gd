extends Damageable

class_name Player

const BULLET = preload("res://scenes/characters/PlayerBullet.tscn")

const max_speed = 60;
const acceleration = 300;
const deceleration = 400;
const shoot_cooldown = 0.5;

var dash_direction := Vector2.ZERO;
var boost_amount := 1.

var selected_ability: int = 0

func _ready():
	hurt.connect(_hurt)
	die.connect(_die)
	Micro.player = self

func _physics_process(delta):
	tick()
	var direction = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	$AimMarker.global_position = get_aim_position()
	$AimMarker.emitting = $ShootCooldown.is_stopped()
	var boosted = !$UltraDuration.is_stopped()
	if dash_direction != Vector2.ZERO:
		velocity = dash_direction * max_speed * 10
	else:
		if direction != Vector2.ZERO:
			velocity = velocity.move_toward(direction * max_speed * boost_amount, acceleration * (2 if boosted else 1) * delta)
		else:
			velocity = velocity.move_toward(Vector2.ZERO, deceleration / boost_amount * delta)
		
	$Character/Render.material.set("shader_parameter/velocity", (velocity / max(max_speed, velocity.length())))
	$Character/Render.material.set("shader_parameter/can_dash", ($Abilities/Dash.can_dash() if has_ability("Dash") else true))
	move_and_slide()
	
	if Input.is_action_pressed("shoot"):
		if $ShootCooldown.time_left > 0: return
		for i in range(0,1):
			var aim = get_local_mouse_position().angle() + i*PI/16
			var bullet = BULLET.instantiate()
			bullet.global_position = get_aim_position()
			bullet.velocity = Vector2.from_angle(aim) * 80. + velocity/2.
			bullet.lifetime = 3. if dash_direction == Vector2.ZERO else .25
			bullet.damage = 10 if dash_direction == Vector2.ZERO else 15
			get_tree().current_scene.get_node("Game/World").add_child(bullet)
		$ShootCooldown.start(shoot_cooldown)
		if dash_direction != Vector2.ZERO:
			$Abilities/Dash.end_dash(true)
	
	if Input.is_action_just_pressed("use_ability") and selected_ability >= 0:
		$Abilities.get_child(selected_ability).activate()
	
	if Input.is_action_just_pressed("next_ability") and selected_ability >= 0:
		selected_ability = wrap(selected_ability + 1, 0, $Abilities.get_children().size() - 1)
	if Input.is_action_just_pressed("previous_ability") and selected_ability >= 0:
		selected_ability = wrap(selected_ability - 1, 0, $Abilities.get_children().size() - 1)

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

func regen_tick():
	heal(1)

func _hurt():
	$HurtEffect.restart()

func _die():
	# todo
	pass

func _do_ultra(duration: float) -> void:
	boost_amount *= (1.5 if boost_amount == 1 else 1.2)
	$UltraDuration.stop()
	$UltraDuration.start(duration)
	$UltraEffect.amount_ratio = -1/boost_amount + 1
	$UltraEffect.modulate.a = -1/boost_amount + 1
	$UltraEffect.emitting = true

func _end_ultra() -> void:
	boost_amount = 1.
	$UltraEffect.emitting = false

func has_ability(ability_name: NodePath) -> bool:
	return $Abilities.has_node(ability_name)
