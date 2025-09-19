extends Upgrade
class_name VitalityUpgrade

static func get_title() -> String:
	return "Vitality"

static func get_description() -> String:
	return "+20% health"

static func get_shader() -> ShaderMaterial:
	return preload("res://entities/player/upgrades/vitality.res")

func get_cost(count: int) -> int:
	return Micro.world.random.randi_range(45,55) + 25 * count

func enable() -> void:
	Micro.player.max_hp += 20
	Micro.player.heal(20)

func disable() -> void:
	Micro.player.max_hp -= 20
	Micro.player.heal(20)
