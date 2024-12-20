extends Node2D

class_name Bullet

@export var velocity: Vector2
@export var lifetime: float

func _ready():
	rotation = velocity.angle() - PI/2
	$Timer.wait_time = lifetime
	$Timer.start()
	pass

func _physics_process(delta):
	rotation = velocity.angle() - PI/2
	global_position += velocity * delta

func _on_expire():
	$AnimationPlayer.play("explode")
	$Particles.emitting = true
	set_physics_process(false)

func _on_collide(_body):
	$AnimationPlayer.play("explode")
	$Particles.emitting = true
	set_physics_process(false)

func _on_animation_finished(anim_name):
	if anim_name == "explode":
		queue_free()
