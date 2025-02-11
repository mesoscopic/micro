extends Node2D

func _ready():
	$ExplosionParticles.emitting = true
	$Ring.emitting = true


func _on_timer_timeout() -> void:
	queue_free()
