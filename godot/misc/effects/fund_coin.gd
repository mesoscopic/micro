extends Node2D

var amount: int = 0
var delay: float = 0

var speed := 150.
var moving: bool = true
var toll: Toll = null
@onready var direction: Vector2 = Vector2.from_angle(Micro.world.random.randf_range(0., 2.*PI))
@onready var spin: float = Micro.world.random.randf_range(-4., 4.)
@onready var point: Vector2 = global_position

func _ready() -> void:
	$Trail.width = 1. + log(amount)*2.

func _physics_process(delta: float) -> void:
	if delay > 0.:
		delay = max(0., delay-delta)
	else:
		if moving:
			var target_pos: Vector2 = (toll.global_position if toll else Micro.player.position)
			speed += 150. * delta
			direction = direction.move_toward(point.direction_to(target_pos), 3.*delta).rotated(spin*delta)
			spin *= .5**delta
			var distance1 := point.distance_squared_to(target_pos);
			point += direction * speed * delta
			$Trail.add_point(point - global_position)
			var distance2 := point.distance_squared_to(target_pos);
			if distance2 < 80.0 and distance1 > distance2:
				moving = false
				$FundsEffect.global_position = point
				$FundsEffect.emitting = true
				if !toll:
					Micro.player.give_funds(amount)
		$Trail.remove_point(0)
		if $Trail.get_point_count() == 0:
			queue_free()
