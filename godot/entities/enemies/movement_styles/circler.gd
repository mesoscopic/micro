class_name CirclerEnemy extends Enemy

@export var retarget_delay: float = 3.0
@export_range(0, 360, 1.0, "radians_as_degrees") var circle_angle_step: float = PI/8.
@export var circle_radius: float = 120.
var circle_angle: float = 0.

func ai_setup() -> void:
	var retarget_timer := Timer.new()
	retarget_timer.autostart = true
	retarget_timer.wait_time = retarget_delay
	retarget_timer.timeout.connect(new_target)
	add_child(retarget_timer)
	circle_angle = get_angle_to(Micro.player.position)

func new_target() -> void:
	circle_angle += circle_angle_step
	path_target = position_target(Micro.player.position + Vector2.from_angle(circle_angle)*circle_radius, false)
