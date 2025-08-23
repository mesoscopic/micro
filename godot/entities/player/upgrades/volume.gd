extends Upgrade
class_name VolumeUpgrade

static func get_title() -> String:
	return "Volume"

static func get_description() -> String:
	return "Larger, slower bullets\n+10% bullet damage"

static func get_shader() -> Shader:
	return preload("res://entities/player/upgrades/volume.gdshader")

func get_cost(_count: int) -> int:
	return 75

func enable() -> void:
	Micro.player.bullet_size_mult += 0.3
	Micro.player.bullet_damage_mult *= 1.1
	Micro.player.bullet_velocity_mult *= 0.85
	Micro.player.bullet_lifetime_mult *= 1.1
	Micro.player.reset_bullets()

func disable() -> void:
	Micro.player.bullet_size_mult -= 0.3
	Micro.player.bullet_damage_mult /= 1.1
	Micro.player.bullet_velocity_mult /= 0.85
	Micro.player.bullet_lifetime_mult /= 1.1
	Micro.player.reset_bullets()
