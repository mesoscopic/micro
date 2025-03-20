extends Node2D

func _ready():
	$ExplosionParticles.emitting = true
	$Ring.emitting = true
	Micro.player.fund_buffer += randi_range(1,1000)

func _on_timer_timeout() -> void:
	queue_free()
