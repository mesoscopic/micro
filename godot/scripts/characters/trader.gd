extends CharacterBody2D
class_name Trader

var speed := 30
var acceleration = 300;
var deceleration = 600;
var wander_distance := 80.;
var wander_range := 240.;
var path_target: Vector2
var last_direction: Vector2 = Vector2.ZERO
var trading: bool = false
var chosen: bool = false:
	set(chosen):
		chosen = chosen
		$Selection.visible = chosen
var item: Upgrade

func _ready() -> void:
	wander()
	item = Micro.generate_trade_item()

func _physics_process(delta: float) -> void:
	if trading:
		velocity = velocity.move_toward(Vector2.ZERO, deceleration * delta / 4.)
	elif global_position.distance_squared_to(path_target) < 100:
		velocity = velocity.move_toward(Vector2.ZERO, deceleration * delta)
		wander()
	else:
		velocity = velocity.move_toward((path_target - global_position).normalized() * speed, acceleration * delta)
	move_and_slide()
	$Character/Render.material.set("shader_parameter/velocity", (velocity / max(speed, velocity.length())))

func wander() -> void:
	var new_target: Vector2 = Vector2.from_angle(PI/2. * randi_range(0,3)) * randf_range(wander_distance/2., wander_distance)
	while check(new_target):
		new_target = Vector2.from_angle(PI/2. * randi_range(0,3)) * randf_range(wander_distance/2., wander_distance)
	path_target = global_position + new_target
	last_direction = new_target.normalized()

func check(to: Vector2) -> bool:
	if to.normalized() == last_direction: return true
	if (global_position + to).length_squared() > wander_range**2: return true
	var query = PhysicsTestMotionParameters2D.new()
	query.from = global_transform
	query.motion = to
	return PhysicsServer2D.body_test_motion(get_rid(), query)

func _on_freeze_range_body_entered(_body: Node2D) -> void:
	set_physics_process(true)

func _on_freeze_range_body_exited(_body: Node2D) -> void:
	set_physics_process(false)

func _on_trade_range_body_entered(_body: Node2D) -> void:
	trading = true
	Micro.player.add_trader(self)

func _on_trade_range_body_exited(_body: Node2D) -> void:
	trading = false
	chosen = false
	Micro.player.traders.erase(self)
	wander()

func happy() -> void:
	if !$HappyParticles.emitting: $HappyParticles.emitting = true
