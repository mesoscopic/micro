extends Damageable

class_name Enemy

const DEATH_ANIMATION = preload("res://scenes/characters/EnemyDeathAnimation.tscn")

func _die():
	var anim = DEATH_ANIMATION.instantiate()
	anim.global_position = global_position
	get_parent().add_child(anim)
	queue_free()

func _hurt():
	$HurtParticles.restart()

func _physics_process(_delta: float) -> void:
	tick()
