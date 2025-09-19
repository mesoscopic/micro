extends Node2D

class_name MineBullet

@export var velocity: Vector2
@export var lifetime: float
@export var damage: int

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
	$Trail.emitting = false
	set_physics_process(false)

func _on_collide(body):
	if body is Mine:
		return
	
	$AnimationPlayer.play("explode")
	$Particles.emitting = true
	$Trail.emitting = false
	set_physics_process(false)
	
	if body is Damageable:
		body.damage(damage, false, body.get_angle_to(global_position))

func _on_animation_finished(anim_name):
	if anim_name == "explode":
		queue_free()
