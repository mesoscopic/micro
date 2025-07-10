extends Area2D

class_name TelegraphedBullet

var shooter: Damageable
var angle_offset: float = 0.
var aim_vec: Vector2
var aim_angle: float
var distance: float
var speed: float
var lifetime: float
var damage: int

@export var is_player: bool = false

var shot: bool = false

func _ready():
	get_tree().create_tween().tween_property($Sprite2D, "instance_shader_parameters/form_anim", 1.0, 0.25)
	rotation = aim_angle - PI/2
	global_position = get_aim_position()
	$Form.emitting = true
	shooter.die.connect(_on_expire)

func get_aim_position() -> Vector2:
	if !shooter: # Failsafe for if the enemy despawns
		queue_free()
		return global_position
	var space_state = get_world_2d().direct_space_state
	var direction = aim_vec * distance + shooter.global_position
	var query = PhysicsRayQueryParameters2D.create(shooter.global_position, direction)
	query.collision_mask = 1 | (int(is_player)<<3)
	var result = space_state.intersect_ray(query)
	
	if result:
		return result.position
	else:
		return direction

func _physics_process(delta):
	rotation = aim_angle - PI/2
	if shot:
		global_position += aim_vec * speed * delta
	else:
		global_position = get_aim_position()

func aim(angle: float):
	aim_vec = Vector2.from_angle(angle + angle_offset)
	aim_angle = angle + angle_offset

func fire():
	monitoring = true
	monitorable = true
	shot = true
	$Timer.wait_time = lifetime
	$Timer.start()
	if shooter.die.is_connected(_on_expire):
		shooter.die.disconnect(_on_expire)

func _on_expire():
	set_physics_process(false)
	set_deferred("monitoring", false)
	set_deferred("monitorable", false)
	var tween := get_tree().create_tween()
	tween.tween_property($Sprite2D, "instance_shader_parameters/dissolve_anim", 1.0, 0.25)
	tween.tween_callback(queue_free)

func _on_collide(body) -> void:
	_on_expire()
	$Impact.emitting = true
	
	if body is Damageable:
		body.damage(damage, false, body.get_angle_to(global_position))
