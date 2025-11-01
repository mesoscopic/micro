extends Upgrade
class_name VitalityUpgrade

static func get_title() -> String:
	return "Vitality"

static func get_description() -> String:
	return "Slowly regenerate health"

static func get_shader() -> ShaderMaterial:
	return preload("res://entities/player/upgrades/vitality.res")

static func available() -> bool:
	return get_count(get_title()) == 0

func get_cost(_count: int) -> int:
	return Micro.world.random.randi_range(100,120)

func enable() -> void:
	Micro.player.regen_rate += 1

func disable() -> void:
	Micro.player.regen_rate += 2
