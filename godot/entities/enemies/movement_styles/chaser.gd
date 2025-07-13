class_name ChaserEnemy extends Enemy

@export var retarget_delay: float = 1.0

func ai_setup() -> void:
	var retarget_timer := Timer.new()
	retarget_timer.autostart = true
	retarget_timer.wait_time = retarget_delay
	retarget_timer.timeout.connect(new_target)
	add_child(retarget_timer)

func new_target() -> void:
	path_target = player_target()
