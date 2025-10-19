extends Upgrade
class_name VitalityUpgrade

static func get_title() -> String:
	return "Vitality"

static func get_description() -> String:
	return "(TODO)"

static func get_shader() -> ShaderMaterial:
	return preload("res://entities/player/upgrades/vitality.res")

static func available() -> bool:
	return get_count(get_title()) == 0

func get_cost(_count: int) -> int:
	return Micro.world.random.randi_range(75,100)

func enable() -> void:
	pass

func disable() -> void:
	pass
