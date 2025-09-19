extends Upgrade
class_name EvasionUpgrade

static func get_title() -> String:
	return "Evasion"

static func get_description() -> String:
	return "Move 25% faster when not shooting\nFaster acceleration and deceleration"

static func get_shader() -> ShaderMaterial:
	return preload("res://entities/player/upgrades/evasion.res")

func get_cost(_count: int) -> int:
	return 50

static func available() -> bool:
	return get_count(get_title()) < 2

func enable() -> void:
	Micro.player.evasion_mult *= 1.25
	Micro.player.acceleration *= 1.25
	Micro.player.deceleration *= 1.25

func disable() -> void:
	Micro.player.evasion_mult /= 1.25
	Micro.player.acceleration /= 1.25
	Micro.player.deceleration /= 1.25
