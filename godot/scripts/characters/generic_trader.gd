extends CharacterBody2D
class_name GenericTrader

var speed := 30
var acceleration = 300
var deceleration = 600
var wander_origin := Vector2.ZERO
var wander_distance := 80.
var wander_range := 240.
var path_target: Vector2
var last_direction: Vector2 = Vector2.ZERO
var first_frame := true

func should_stop() -> bool:
	return false

func _physics_process(delta: float) -> void:
	if first_frame:
		first_frame = false
		wander()
		return
	if should_stop():
		velocity = velocity.move_toward(Vector2.ZERO, deceleration * delta / 4.)
	elif global_position.distance_squared_to(path_target) < 100:
		velocity = velocity.move_toward(Vector2.ZERO, deceleration * delta)
		wander()
	else:
		velocity = velocity.move_toward((path_target - global_position).normalized() * speed, acceleration * delta)
	move_and_slide()
	$Render.material.set("shader_parameter/velocity", (velocity / max(speed, velocity.length())))

func wander() -> void:
	var new_target: Vector2 = Vector2.from_angle(PI/2. * randi_range(0,3)) * randf_range(wander_distance/2., wander_distance)
	while check(new_target):
		new_target = Vector2.from_angle(PI/2. * randi_range(0,3)) * randf_range(wander_distance/2., wander_distance)
	path_target = global_position + new_target
	last_direction = new_target.normalized()

func check(to: Vector2) -> bool:
	if to.normalized() == last_direction: return true
	if (global_position + to - wander_origin).length_squared() > wander_range**2: return true
	var query = PhysicsTestMotionParameters2D.new()
	query.from = global_transform
	query.motion = to
	return PhysicsServer2D.body_test_motion(get_rid(), query)
