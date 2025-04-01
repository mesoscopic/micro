extends Resource
class_name Upgrade

var render: ShaderMaterial
var title := "Upgrade"
var description := "Upgrades you"
var cost: int

func enable() -> void:
	pass

func disable() -> void:
	pass

func set_cost(base_cost) -> void:
	cost = base_cost + round(base_cost*randf_range(-0.1,0.1))
