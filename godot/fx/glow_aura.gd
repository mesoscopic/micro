extends Node2D

@export var brightness := 0.:
	set(b):
		brightness = b
		$Render.set_instance_shader_parameter("brightness", b)

func _ready() -> void:
	$Render.set_instance_shader_parameter("brightness", brightness)
