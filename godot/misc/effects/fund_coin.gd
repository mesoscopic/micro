extends Node2D

var amount: int = 0
var delay: float = 0

var speed := 150.
var moving: bool = true
@onready var direction: Vector2 = Vector2.from_angle(randf_range(0., 2.*PI))
@onready var point: Vector2 = global_position

func _ready() -> void:
	$Trail.width = 1. + log(amount)*2.

func _physics_process(delta: float) -> void:
	if delay > 0.:
		delay = max(0., delay-delta)
	else:
		if moving:
			speed += 150. * delta
			direction = direction.move_toward(point.direction_to(Micro.player.position), 3.*delta)
			var distance1 := point.distance_squared_to(Micro.player.position);
			point += direction * speed * delta
			$Trail.add_point(point - global_position)
			var distance2 := point.distance_squared_to(Micro.player.position);
			if distance2 < 80.0 and distance1 > distance2:
				Micro.player.give_funds(amount)
				moving = false
		$Trail.remove_point(0)
		if $Trail.get_point_count() == 0:
			queue_free()
