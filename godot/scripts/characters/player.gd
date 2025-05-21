extends Damageable

class_name Player

const BULLET = preload("res://scenes/bullets/PlayerBullet.tscn")

var movement_disabled := false
var max_speed = 60
var acceleration = 300
var deceleration = 400
var shoot_cooldown = 0.5

var multishot: int = 0
var bullet_damage_mult: float = 1.
var shoot_cooldown_mult: float = 1.
var bullet_lifetime_mult: float = 1.
var bullet_spread: float = 0.
var evasion_mult: float = 1.
var bullet_velocity_mult: float = 1.
var bullet_size_mult: float = 1.

var dash_direction := Vector2.ZERO;

var selected_ability: int = 0

var funds: int = 0
var trading: bool = false
var traders: Array[Trader] = []
var chosen_trader: Trader

func _ready():
	hurt.connect(_hurt)
	die.connect(_die)
	Micro.player = self
	$FundsDisplay/HBoxContainer/Label.text = "%s" % funds

func _physics_process(delta):
	tick()
	if movement_disabled: return
	var direction = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	$AimMarker.global_position = get_aim_position()
	$AimMarker.emitting = $ShootCooldown.is_stopped()
	if dash_direction != Vector2.ZERO:
		velocity = dash_direction * max_speed * 10
	else:
		if direction != Vector2.ZERO:
			velocity = velocity.move_toward(direction * max_speed * (evasion_mult if $ShootCooldown.is_stopped() else 1.), acceleration * delta)
		else:
			velocity = velocity.move_toward(Vector2.ZERO, deceleration * delta)
		
	$Character/Render.material.set("shader_parameter/velocity", (velocity / max(max_speed, velocity.length())))
	$Character/Render.material.set("shader_parameter/can_dash", ($Abilities.get_child(selected_ability).available() if selected_ability >= 0 else true))
	move_and_slide()
	
	if Input.is_action_pressed("shoot"):
		if $ShootCooldown.time_left > 0: return
		for i in range(-multishot,multishot+1):
			var aim = get_local_mouse_position().angle()
			aim += i*PI/16 + randf_range(-1,1)*bullet_spread
			var bullet = BULLET.instantiate()
			bullet.global_position = get_aim_position()
			bullet.velocity = Vector2.from_angle(aim) * 80. * (1+0.5*velocity.length()/max_speed) * bullet_velocity_mult
			bullet.lifetime = (3. if dash_direction == Vector2.ZERO else .25)*bullet_lifetime_mult
			bullet.damage = ceil(10*bullet_damage_mult) if dash_direction == Vector2.ZERO else ceil(15*bullet_damage_mult)
			bullet.scale = Vector2(bullet_size_mult, bullet_size_mult)
			get_tree().current_scene.get_node("Game/World").add_child(bullet)
		$ShootCooldown.start(shoot_cooldown*shoot_cooldown_mult)
		if dash_direction != Vector2.ZERO:
			$Abilities/Dash.end_dash(true)
	
	if Input.is_action_just_pressed("use_ability") and selected_ability >= 0:
		$Abilities.get_child(selected_ability).activate()
	
	if Input.is_action_just_pressed("next_ability") and selected_ability >= 0:
		selected_ability = wrap(selected_ability + 1, 0, $Abilities.get_children().size() - 1)
	if Input.is_action_just_pressed("previous_ability") and selected_ability >= 0:
		selected_ability = wrap(selected_ability - 1, 0, $Abilities.get_children().size() - 1)
		
	if trading:
		if traders.size() == 0:
			trading = false
			$FundsDisplay/AnimationPlayer.stop()
			$FundsDisplay/AnimationPlayer.play("hide_funds")
			Micro.hide_trading()
			chosen_trader = null
		else:
			traders.sort_custom(func(a, b): return a.global_position.distance_squared_to(position) < b.global_position.distance_squared_to(position))
			for i in range(traders.size()):
				if i == 0:
					# closest trader
					traders[i].chosen = true
					if traders[i] != chosen_trader:
						chosen_trader = traders[i]
						Micro.show_trade_information(chosen_trader)
				else:
					traders[i].chosen = false

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

func _hurt(amount: int):
	$HurtEffect.restart()
	if !Micro.setting("photosensitive_mode"): $Camera.hurt(clamp(float(amount)/float(hp), 0., 1.))

func _die():
	if !Micro.setting("photosensitive_mode"): $Camera.hurt(2.)
	invincible = true
	var slow = create_tween().set_ignore_time_scale(true)
	slow.tween_property(Engine, "time_scale", 0.1, .8)
	await slow.finished
	process_mode = Node.PROCESS_MODE_DISABLED
	Engine.time_scale = 1.
	$DeathParticles.emitting = true
	$Character.hide()
	$Ring.emitting = true
	await Micro.wait(1., true)
	await Micro.screen_wipe_out()
	get_tree().current_scene._on_death()

func _input(event: InputEvent) -> void:
	if !movement_disabled and trading and event.is_action_pressed("ui_accept"):
		Micro.attempt_trade(chosen_trader)

func has_ability(ability_name: NodePath) -> bool:
	return $Abilities.has_node(ability_name)

func give_funds(amount: int) -> void:
	funds += amount
	if !Micro.setting("photosensitive_mode"): $FundsEffect.emit_particle(get_transform(), Vector2.ZERO, Color.WHITE, Color.WHITE, 0)
	$FundsDisplay/HBoxContainer/Label.text = "%s" % funds
	$FundsDisplay/AnimationPlayer.stop()
	$FundsDisplay/AnimationPlayer.play(
		("show_funds_simple" if Micro.setting("photosensitive_mode") else "show_funds")
		if trading else # get_funds causes FundsDisplay to disappear, so we instead use show_funds which does not,
						# but we still need a photosensitive version in this case
		("get_funds_simple" if Micro.setting("photosensitive_mode") else "get_funds"))

func add_trader(trader: Trader) -> void:
	traders.append(trader)
	if trading: return
	trading = true
	$FundsDisplay/AnimationPlayer.stop()
	$FundsDisplay/AnimationPlayer.play("show_funds")
