extends Upgrade
class_name MultishotUpgrade

static func get_title() -> String:
	return "Multishot"

static func get_description() -> String:
	return "Fire +2 bullets every shot"

static func get_shader() -> ShaderMaterial:
	return preload("res://entities/player/upgrades/multishot.res")

func get_cost(count: int) -> int:
	return Micro.world.random.randi_range(100, 110) + 40 * count

static func available() -> bool:
	return get_count(get_title()) < 3

func enable() -> void:
	Micro.player.multishot += 1
	Micro.player.reset_bullets()

func disable() -> void:
	Micro.player.multishot -= 1
	Micro.player.reset_bullets()
