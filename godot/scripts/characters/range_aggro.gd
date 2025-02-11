extends AggroMethod

@export var aggro_range: int = 100
@export var deaggro_range: int = 200

func _ready() -> void:
	$AggroRange.scale = Vector2(aggro_range, aggro_range)
	$DeaggroRange.scale = Vector2(deaggro_range, deaggro_range)

func _on_aggro_range_body_entered(_body: Node2D) -> void:
	aggro()

func _on_deaggro_range_body_exited(_body: Node2D) -> void:
	deaggro()
