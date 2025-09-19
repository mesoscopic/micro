extends Upgrade
class_name RecklessnessUpgrade

static func get_title() -> String:
	return "Recklessness"

static func get_description() -> String:
	return "Shoot 20% faster, but lose 50% invincibility time"

static func get_shader() -> ShaderMaterial:
	return preload("res://entities/player/upgrades/recklessness.res")

func get_cost(count: int) -> int:
	return Micro.world.random.randi_range(80, 90) + 30*count

static func available() -> bool:
	return get_count(get_title()) < 3

func enable() -> void:
	Micro.player.shoot_cooldown *= 0.8
	Micro.player.invulnerability_time *= 0.5

func disable() -> void:
	Micro.player.shoot_cooldown /= 0.8
	Micro.player.invulnerability_time /= 0.5
