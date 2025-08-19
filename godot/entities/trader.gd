class_name Trader extends CharacterBody2D

enum TraderState {
	WILD,
	COLLECTING,
	COLLECTED
}

var state := TraderState.WILD

var speed := 30
var acceleration := 300.
var deceleration := 600.
var wander_origin := Vector2.ZERO
var wander_distance := 80.
var wander_range := 240.
var path_target: Vector2
var last_direction: Vector2 = Vector2.ZERO
var first_frame := true

var trading: bool = false
var item: Upgrade

func should_stop() -> bool:
	match state:
		TraderState.WILD:
			return false
		TraderState.COLLECTED:
			return trading
		_:
			return true

func init_state(new_state: TraderState) -> void:
	match new_state:
		TraderState.WILD:
			wander_origin = position
			state = new_state
			wander()
		TraderState.COLLECTED:
			if state == TraderState.COLLECTING:
				wander_range = 200.
				wander_distance = 80.
			Micro.world.refresh_trades.connect(refresh_item)
			state = new_state
			$Toll.enabled = true
			Micro.world.refresh_trades.emit()
			wander()
		_:
			state = new_state

func _physics_process(delta: float) -> void:
	if first_frame:
		first_frame = false
		init_state(state)
		return
	if should_stop():
		velocity = velocity.move_toward(Vector2.ZERO, deceleration * delta / 4.)
	elif global_position.distance_squared_to(path_target) < 100:
		velocity = velocity.move_toward(Vector2.ZERO, deceleration * delta)
		wander()
	else:
		velocity = velocity.move_toward((path_target - global_position).normalized() * speed, acceleration * delta)
	move_and_slide()
	$Render.set_instance_shader_parameter("velocity", (velocity / max(speed, velocity.length())))

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

func collect() -> void:
	$CollectArea.set_deferred("monitoring", false)
	$CollectArea.set_deferred("monitorable", false)
	$CollectParticles.emitting = true
	init_state(TraderState.COLLECTING)
	await Micro.wait(1.)
	var house: Vector2 = Micro.world.houses.pop_front()*20.
	var charge_anim = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_EXPO).tween_property(self, "position", position+(position-house).normalized()*60., 1.)
	await charge_anim.finished
	$SpeedParticles.emitting = true
	var move_anim = create_tween().tween_property(self, "position", house, (position-house).length()/500.)
	await move_anim.finished
	$SpeedParticles.emitting = false
	wander_origin = house
	init_state(TraderState.COLLECTED)
	if !$OnScreenDetector.is_on_screen():
		process_mode = Node.PROCESS_MODE_DISABLED
		$SpeedParticles.hide()

func _on_collect_area_entered(body: Node2D) -> void:
	if body != Micro.player or state != TraderState.WILD: return
	collect()

func refresh_item() -> void:
	var weights = RollWeights.new()
	weights.add_item(MultishotUpgrade, 1)
	weights.add_item(RecklessnessUpgrade, 3)
	weights.add_item(EvasionUpgrade, 2)
	weights.add_item(VolumeUpgrade, 2)
	weights.add_item(VitalityUpgrade, 4)
	item = Micro.roll(weights).new()
	$Toll.set_for_upgrade(item)

func _on_enter_screen() -> void:
	process_mode = Node.PROCESS_MODE_INHERIT

func _on_exit_screen() -> void:
	if state != TraderState.COLLECTING:
		process_mode = Node.PROCESS_MODE_DISABLED

func _on_toll_chosen() -> void:
	$HappyParticles.emitting = true

func _on_toll_unchosen() -> void:
	$HappyParticles.emitting = false

func _on_toll_enter_range() -> void:
	trading = true

func _on_toll_leave_range() -> void:
	trading = false

func _on_toll_paid() -> void:
	await Micro.wait(1.)
	get_tree().create_tween().set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_CUBIC).tween_property(Micro.player.get_node("Camera"), "global_position", Vector2.ZERO, 0.5)
	Micro.world.purchase_upgrade.emit(item)
	await Micro.world.upgrade_purchased
	Micro.world.refresh_trades.emit()
	await Micro.wait(1.)
	Micro.show_trade_information(Micro.player.chosen_toll)
	Micro.player.movement_disabled = false
	get_tree().create_tween().set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_CUBIC).tween_property(Micro.player.get_node("Camera"), "position", Vector2.ZERO, 0.5)
