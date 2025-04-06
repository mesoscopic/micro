extends Line2D
class_name HealRay

@export var healing: float

var lifetime: float = 1.
var healed: float = 0.

var active: bool = false

func start() -> void:
	active = true
	healed = 0
	lifetime = 1
	set_point_position(1, Micro.player.position-global_position)
	create_tween().tween_property(self, "width", 20., 0.25)

func _process(delta: float) -> void:
	if !active: return
	set_point_position(1, Micro.player.position-global_position)
	lifetime -= delta
	healed += healing*delta
	while healed >= 1:
		Micro.player.heal(1)
		healed -= 1
	if lifetime <= 0:
		active = false
		create_tween().tween_property(self, "width", 0., 0.25)
