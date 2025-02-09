extends Node2D

func _ready():
	$ExplosionParticles.emitting = true
	$Ring.emitting = true
	await Micro.wait(3)
	queue_free()
