extends Upgrade
class_name RecklessnessUpgrade

static func get_title() -> String:
	return "Recklessness"

static func get_description() -> String:
	return "-20% recharge time, +5° spread"

static func get_shader() -> Shader:
	return preload("res://entities/player/upgrades/recklessness.gdshader")

func get_cost(_count: int) -> int:
	return 60

func enable() -> void:
	Micro.player.shoot_cooldown_mult *= 0.8
	Micro.player.bullet_spread += PI/36.

func disable() -> void:
	Micro.player.shoot_cooldown_mult /= 0.8
	Micro.player.bullet_spread -= PI/36.
