class_name PlayerDamageCloud extends Area2D

@export var lifetime := 1.
@export var damage := 10

func _ready() -> void:
	var tween = get_tree().create_tween()
	tween.tween_property($Render, "instance_shader_parameters/progress", 1., lifetime)
	tween.tween_callback(queue_free)

func _physics_process(_delta: float):
	for body in get_overlapping_bodies():
		if body is Damageable:
			body.damage(damage, false, get_angle_to(body.global_position))
