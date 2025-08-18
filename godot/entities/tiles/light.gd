extends Node2D

func _ready() -> void:
	$Clouds.set_instance_shader_parameter("angle", -global_position.normalized())

func activate(body: Node2D) -> void:
	if body != Micro.player: return
	$Activate.restart()
	$Render.modulate = Color.WHITE
	$Illumination.emitting = true
	get_tree().create_tween().tween_property($Clouds, "modulate", Color.WHITE, 1.)
	$Detection.queue_free()
