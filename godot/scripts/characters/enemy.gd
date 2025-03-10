extends Damageable

class_name Enemy

@export var speed := 50
@export var acceleration = 300;
@export var deceleration = 400;
var speed_multiplier := 1.
@export var turn_length := 50
@export var wander_length := 100
@export var wander_speed_mult := .5
var path_target: Vector2
var wandering: bool = true

const DEATH_ANIMATION = preload("res://scenes/characters/EnemyDeathAnimation.tscn")

signal aggro
signal deaggro
signal repath

@onready var aggro_methods: Array = find_children("*", "AggroMethod")
var is_aggro = false

func _ready():
	hurt.connect(_hurt)
	die.connect(_die)
	for method in aggro_methods:
		method.aggro_changed.connect(change_aggro)
	wander()

func _die():
	var anim = DEATH_ANIMATION.instantiate()
	anim.global_position = global_position
	get_parent().add_child(anim)
	queue_free()

func _hurt():
	$HurtParticles.restart()

func _physics_process(delta: float) -> void:
	tick()
	if global_position.distance_squared_to(path_target) < 100:
		velocity = velocity.move_toward(Vector2.ZERO, deceleration * delta)
		if wandering:
			path_target = wander_target()
			repath.emit()
		else:
			path_target = player_target()
			repath.emit()
	else:
		velocity = velocity.move_toward((path_target - global_position).normalized() * speed * (wander_speed_mult if wandering else speed_multiplier), 100 * delta)
	move_and_slide()
	$Character/Render.material.set("shader_parameter/velocity", (velocity / max(speed, velocity.length())))

func change_aggro(_method: AggroMethod):
	var should_aggro: bool = false
	for aggro_method in aggro_methods:
		if aggro_method.is_aggro:
			should_aggro = true
			break
	if should_aggro and !is_aggro:
		is_aggro = true
		aggro.emit()
	if !should_aggro and is_aggro:
		is_aggro = false
		deaggro.emit()

func wander_target() -> Vector2:
	var new_target := global_position + Vector2.from_angle(randf_range(0,2*PI)) * wander_length
	while raycast(new_target):
		new_target = global_position + Vector2.from_angle(randf_range(0,2*PI)) * wander_length
	return new_target

func player_target() -> Vector2:
	if raycast(Micro.player.position):
		var angle1 := get_angle_to(Micro.player.position)
		var angle2 := get_angle_to(Micro.player.position)
		while raycast(Vector2.from_angle(angle1) * turn_length + global_position) && raycast(Vector2.from_angle(angle2) * turn_length + global_position):
			angle1 -= PI/8.
			angle2 += PI/8.
		if !raycast(Vector2.from_angle(angle1) * turn_length + global_position):
			return Vector2.from_angle(angle1) * turn_length + global_position
		elif !raycast(Vector2.from_angle(angle2) * turn_length + global_position):
			return Vector2.from_angle(angle2) * turn_length + global_position
	return Micro.player.position

func raycast(to: Vector2, from: Vector2 = global_position) -> bool:
	var query = PhysicsRayQueryParameters2D.create(from, to, 1)
	return get_world_2d().direct_space_state.intersect_ray(query) != {}

func target_player():
	wandering = false
	path_target = player_target()
	repath.emit()

func wander():
	wandering = true
	path_target = wander_target()
	repath.emit()
