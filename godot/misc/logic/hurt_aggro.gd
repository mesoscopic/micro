extends AggroMethod

@export var aggro_length: float = 5

func _ready() -> void:
	parent.hurt.connect(on_hurt)
	$Timer.wait_time = aggro_length

func on_hurt(_amount: int, _direction: float) -> void:
	aggro()
	$Timer.stop()
	$Timer.start()

func _on_timer_timeout() -> void:
	deaggro()
