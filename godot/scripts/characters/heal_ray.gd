extends Line2D
class_name HealRay

var heal_rate: float
var lifetime: float = 1.
var healed: float = 0.
var target: Damageable = null
var infinite: bool = false
var active: bool = false

func heal(t: Damageable, r: float, l: float) -> void:
	target = t
	t.die.connect(stop)
	if l == 0.:
		lifetime = 1.
		infinite = true
	else:
		lifetime = l
		infinite = false
	heal_rate = r
	healed = 0
	active = true
	set_point_position(1, target.global_position-global_position)
	create_tween().tween_property(self, "width", 20., 0.25)

func stop() -> void:
	target.die.disconnect(stop)
	active = false
	create_tween().tween_property(self, "width", 0., 0.25)

func _process(delta: float) -> void:
	if !active: return
	set_point_position(1, target.global_position-global_position)
	if !infinite: lifetime -= delta
	healed += heal_rate*delta
	while healed >= 1:
		Micro.player.heal(1)
		healed -= 1
	if lifetime <= 0:
		stop()
