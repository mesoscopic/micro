extends Damageable

class_name Player

const BULLET = preload("res://bullets/PlayerBullet.tscn")

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

var dash_direction := Vector2.ZERO
var aim_direction := Vector2.RIGHT

@export var funds: int = 0
var trading: bool = false
var tolls: Array[Toll] = []
var chosen_toll: Toll
var prepared_bullets: Array[TelegraphedBullet]

func _ready():
	super()
	hurt.connect(_hurt)
	die.connect(_die)
	Micro.player = self
	$FundsDisplay/HBoxContainer/Label.text = "%s" % funds

func _physics_process(delta):
	tick()
	if movement_disabled: return
	var direction = motion_input()
	for bullet in prepared_bullets:
		bullet.aim(aim_input().angle())
	if dash_direction != Vector2.ZERO:
		velocity = dash_direction * max_speed * 10
	else:
		if direction != Vector2.ZERO:
			velocity = velocity.move_toward(direction * max_speed * (evasion_mult if $ShootCooldown.is_stopped() else 1.), acceleration * delta)
		else:
			velocity = velocity.move_toward(Vector2.ZERO, deceleration * delta)
	move_and_slide()
	
	# Bounce if you collided while dashing
	if dash_direction != Vector2.ZERO:
		var collision = get_last_slide_collision()
		if collision:
			Micro.rumble(true, .10)
			velocity = -dash_direction * max_speed * 2.
			end_dash()
	
	$Render.material.set("shader_parameter/velocity", (velocity / max(max_speed, velocity.length())))
	$Render.material.set("shader_parameter/can_dash", $DashCooldown.is_stopped())
	
	if Input.is_action_pressed("shoot") and len(prepared_bullets) > 0:
		var ultra := false
		if dash_direction != Vector2.ZERO:
			Micro.rumble(true, .15)
			velocity = -dash_direction * max_speed * 4.
			end_dash()
			ultra = true
		for bullet in prepared_bullets:
			bullet.speed = 120.*(4.0 if ultra else 1.0) * bullet_velocity_mult
			bullet.lifetime = (.25 if ultra else 1.5) * bullet_lifetime_mult
			bullet.damage = ceil(10*bullet_damage_mult) if dash_direction == Vector2.ZERO else ceil(15*bullet_damage_mult)
			bullet.fire()
		prepared_bullets = []
		$ShootCooldown.start(shoot_cooldown*shoot_cooldown_mult)
	
	if Input.is_action_just_pressed("dash") and $DashCooldown.is_stopped():
		start_dash(aim_input())
		
	if trading:
		if tolls.size() == 0:
			trading = false
			$FundsDisplay/AnimationPlayer.stop()
			$FundsDisplay/AnimationPlayer.play("hide_funds")
			Micro.hide_trading()
			chosen_toll = null
		else:
			tolls.sort_custom(func(a, b): return a.global_position.distance_squared_to(position) < b.global_position.distance_squared_to(position))
			for i in range(tolls.size()):
				if i == 0:
					# closest trader
					tolls[i].set_chosen(true)
					if tolls[i] != chosen_toll:
						chosen_toll = tolls[i]
						Micro.show_trade_information(chosen_toll)
				else:
					tolls[i].set_chosen(false)

func _hurt(amount: int, direction: float):
	Micro.rumble(true, .2)
	$HurtEffect.hurt(amount, direction)
	if !Micro.get_setting("photosensitive_mode"): $Camera.hurt(clamp(float(amount)/float(hp), 0., 1.))

func _die():
	if !Micro.get_setting("photosensitive_mode"): $Camera.hurt(2., true)
	invincible = true
	var slow = create_tween().set_ignore_time_scale(true)
	slow.tween_property(Engine, "time_scale", 0.1, .8)
	prepared_bullets = []
	await slow.finished
	process_mode = Node.PROCESS_MODE_DISABLED
	Engine.time_scale = 1.
	$DeathParticles.emitting = true
	$Render.hide()
	$Ring.emitting = true
	await Micro.wait(1., true)
	await Micro.screen_wipe_out()
	get_tree().current_scene._on_death()

func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		aim_direction = get_local_mouse_position().normalized()
	if !movement_disabled and trading and event.is_action_pressed("ui_accept"):
		Micro.attempt_payment(chosen_toll)

func give_funds(amount: int) -> void:
	funds += amount
	if !Micro.get_setting("photosensitive_mode"): $FundsEffect.emit_particle(get_transform(), Vector2.ZERO, Color.WHITE, Color.WHITE, 0)
	$FundsDisplay/HBoxContainer/Label.text = "%s" % funds
	$FundsDisplay/AnimationPlayer.stop()
	$FundsDisplay/AnimationPlayer.play(
		("show_funds_simple" if Micro.get_setting("photosensitive_mode") else "show_funds")
		if trading else # get_funds causes FundsDisplay to disappear, so we instead use show_funds which does not,
						# but we still need a photosensitive version in this case
		("get_funds_simple" if Micro.get_setting("photosensitive_mode") else "get_funds"))

func add_toll(toll: Toll) -> void:
	tolls.append(toll)
	if trading: return
	trading = true
	$FundsDisplay/AnimationPlayer.stop()
	$FundsDisplay/AnimationPlayer.play("show_funds")

func prepare_bullet() -> void:
	for i in range(-multishot,multishot+1):
		var bullet: TelegraphedBullet = preload("res://bullets/PlayerBullet.tscn").instantiate()
		bullet.shooter = self
		bullet.angle_offset = i*PI/16 + randf_range(-1,1)*bullet_spread
		bullet.aim(aim_input().angle())
		bullet.distance = 20
		bullet.scale = Vector2(bullet_size_mult, bullet_size_mult)
		Micro.world.get_node("Bullets").add_child(bullet)
		prepared_bullets.append(bullet)

func reset_bullets():
	for bullet in prepared_bullets:
		bullet._on_expire()
	prepared_bullets = []
	$ShootCooldown.start(shoot_cooldown*shoot_cooldown_mult)

func _on_dash_hit(body: Node2D) -> void:
	if body is Damageable:
		body.damage(20, false, dash_direction.angle())

func _on_dash_end() -> void:
	velocity = dash_direction * max_speed
	end_dash()

func end_dash() -> void:
	$DashDuration.stop()
	invincible = false
	$DashArea.monitoring = false
	$Dashline.emitting = false
	$Afterimage.emitting = false
	dash_direction = Vector2.ZERO

func _on_dash_cooldown_timeout() -> void:
	$DashRestore.emitting = true

func motion_input() -> Vector2:
	var swap := bool(Micro.get_setting("swap_joysticks"))
	var joy_vector := Input.get_vector(
		"aim_left" if swap else "move_left_joy",
		"aim_right" if swap else "move_right_joy",
		"aim_up" if swap else "move_up_joy",
		"aim_down" if swap else "move_down_joy"
	)
	if joy_vector == Vector2.ZERO:
		return Input.get_vector("move_left_key", "move_right_key", "move_up_key", "move_down_key")
	else:
		return joy_vector.normalized()

func aim_input() -> Vector2:
	var swap := bool(Micro.get_setting("swap_joysticks"))
	var joy_vector := Input.get_vector(
		"move_left_joy" if swap else "aim_left",
		"move_right_joy" if swap else "aim_right",
		"move_up_joy" if swap else "aim_up",
		"move_down_joy" if swap else "aim_down"
	).normalized()
	if joy_vector != Vector2.ZERO: aim_direction = joy_vector
	return aim_direction

func start_dash(direction: Vector2) -> void:
	invincible = true
	$DashArea.monitoring = true
	$DashDuration.start()
	$DashCooldown.start()
	$Afterimage.emitting = true
	dash_direction = direction
	$Dashline.rotation = dash_direction.angle()
	$Dashline.emitting = true
	Micro.rumble(false, .15)
