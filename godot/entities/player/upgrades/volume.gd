extends Upgrade
class_name VolumeUpgrade

static func get_title() -> String:
	return "Volume"

static func get_description() -> String:
	return "Enlarge bullets, making them deal 30% more damage"

static func get_shader() -> ShaderMaterial:
	return preload("res://entities/player/upgrades/volume.res")

func get_cost(count: int) -> int:
	return Micro.world.random.randi_range(60, 75) + 40 * count

func enable() -> void:
	Micro.player.bullet_size_mult += 0.2
	Micro.player.bullet_damage_mult *= 1.3
	Micro.player.reset_bullets()

func disable() -> void:
	Micro.player.bullet_size_mult -= 0.2
	Micro.player.bullet_damage_mult /= 1.3
	Micro.player.reset_bullets()
