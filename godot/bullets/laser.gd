class_name LaserBullet extends Area2D

## The length of the laser beam, in units.
@export var length: float = 400.:
	set(len):
		length = len
		$Laser.set_point_position(1, Vector2(len, 0))
		$Laser.set_instance_shader_parameter("line_length", len)
		$Collision.scale = Vector2(len, 1.)
@export var lifetime: float = 5.
@export var damage: int = 20

var damage_length := 0.

func _ready() -> void:
	var tween = get_tree().create_tween()
	tween.tween_property($Laser, "instance_shader_parameters/appear", 1.2, 0.25)

func _physics_process(_delta: float) -> void:
	for body in get_overlapping_bodies():
		if body is Damageable and global_position.distance_to(body.global_position) < damage_length*length*scale.x:
			body.damage(damage, false, rotation)

func fire(extend_time: float = 0.25) -> void:
	var tween := get_tree().create_tween()
	tween.tween_property(self, "damage_length", 1., extend_time)
	tween.parallel().tween_property($Laser, "instance_shader_parameters/activate", 1.2, extend_time)
	$Lifetime.start(lifetime)

func stop() -> void:
	$Lifetime.stop()
	var tween := get_tree().create_tween()
	tween.tween_property(self, "damage_length", 0., 0.5)
	tween.parallel().tween_property($Laser, "instance_shader_parameters/disappear", 1.2, 0.5)
	tween.tween_callback(queue_free)
