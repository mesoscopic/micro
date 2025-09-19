extends Damageable

class_name Enemy

@export var speed := 50
@export var acceleration = 100;
@export var deceleration = 400;
var speed_multiplier := 1.
@export var turn_length := 50
var path_target: Vector2
var starting_position: Vector2
var can_set_start: bool = true
@export var fund_drop: int = 0
@export var fund_drop_randomization: float = 0.1
@export var despawn_distance := 500
@onready var despawn_distance_squared: float = despawn_distance**2
@export var stagger_time: float = 0.1
var stagger: float = 0.
@export var is_boss: bool = false
@export var is_void: bool = false
var extra_reward: Callable

var DEATH_ANIMATION := preload("res://fx/death/Enemy.tscn")

signal despawn

var is_aggro = false

func _ready():
	super()
	hurt.connect(_hurt)
	die.connect(_die)
	ai_setup()
	new_target()
	if is_boss:
		Micro.world.bosses_active += 1

func ai_setup() -> void:
	pass

func new_target() -> void:
	pass

func _die():
	var anim = DEATH_ANIMATION.instantiate()
	anim.fund_drop = fund_drop + fund_drop*fund_drop_randomization*randf_range(-1.,1.)
	anim.enemy_scale = $Render.scale.x
	anim.position = position
	anim.extra_reward = extra_reward
	add_sibling(anim)
	if is_boss:
		Micro.world.bosses_active -= 1
	queue_free()

func _hurt(amount: int, direction: float):
	stagger = stagger_time
	$HurtEffect.hurt(amount, direction)

func _physics_process(delta: float) -> void:
	tick()
	if stagger > 0.:
		stagger = max(0., stagger-delta)
		velocity = velocity.move_toward(Vector2.ZERO, deceleration * delta / 2)
	elif speed == 0.:
		# Optimize for frozen enemies
		if despawn_distance > 0 and global_position.distance_squared_to(Micro.player.position) > despawn_distance_squared:
			do_despawn()
	else:
		if global_position.distance_squared_to(path_target) < 100:
			velocity = velocity.move_toward(Vector2.ZERO, deceleration * delta)
			new_target()
		elif despawn_distance > 0 and global_position.distance_squared_to(Micro.player.position) > despawn_distance_squared:
			do_despawn()
		else:
			velocity = velocity.move_toward((path_target - global_position).normalized() * speed * speed_multiplier, acceleration * delta)
	move_and_slide()
	$Render.set_instance_shader_parameter("velocity", velocity / max(speed if speed > 0 else 1, velocity.length()))

func position_target(target: Vector2, avoid_start: bool) -> Vector2:
	if check(target):
		if can_set_start:
			starting_position = global_position
			can_set_start = false
		var angle1 := get_angle_to(target)
		var angle2 := get_angle_to(target)
		var fallback: bool = true
		for i in range(0,9):
			if !(check(Vector2.from_angle(angle1) * turn_length + global_position, avoid_start) && check(Vector2.from_angle(angle2) * turn_length + global_position, avoid_start)):
				fallback = false
				break
			angle1 -= PI/8.
			angle2 += PI/8.
		if fallback:
			return target
		if !check(Vector2.from_angle(angle1) * turn_length + global_position):
			return Vector2.from_angle(angle1) * turn_length + global_position
		elif !check(Vector2.from_angle(angle2) * turn_length + global_position):
			return Vector2.from_angle(angle2) * turn_length + global_position
	can_set_start = true
	return target

func player_target() -> Vector2:
	return position_target(Micro.player.position, true)

func check(to: Vector2, avoid_starting_position: bool = false) -> bool:
	if avoid_starting_position && (starting_position.distance_squared_to(to) <= starting_position.distance_squared_to(global_position)): return true
	# Enemies will not cross the world border
	if is_void != bool(abs(to.x) + abs(to.y) > 10240.): return true
	var query = PhysicsTestMotionParameters2D.new()
	query.from = global_transform
	query.motion = to - global_position
	return PhysicsServer2D.body_test_motion(get_rid(), query)

func do_despawn():
	if is_boss:
		Micro.world.bosses_active -= 1
	despawn.emit()
	# 50% chance of doing another spawn attempt if this one despawns
	# Since a lot of enemies that spawn will wander away from the player, this increases the likelihood of the player running into an enemy
	if randi_range(1,2) == 1: Micro.world.spawn_attempt()
	queue_free()
