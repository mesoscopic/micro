extends Upgrade
class_name ForceUpgrade

static func get_title() -> String:
	return "Force"

static func get_description() -> String:
	return "Dash faster, dealing more damage"

static func get_shader() -> ShaderMaterial:
	return preload("res://entities/player/upgrades/force.res")

func get_cost(count: int) -> int:
	return Micro.world.random.randi_range(50, 60) + 25*count

static func available() -> bool:
	return get_count(get_title()) < 3

func enable() -> void:
	Micro.player.dash_power += 0.2
	Micro.player.dash_damage += 10

func disable() -> void:
	Micro.player.dash_power += 0.2
	Micro.player.dash_damage += 10
