extends Upgrade
class_name VolumeUpgrade

func _init() -> void:
	title = "Volume"
	description = "Larger, slower bullets\n+10% bullet damage"
	render = ShaderMaterial.new()
	render.shader = preload("res://entities/player/upgrades/volume.gdshader")
	set_cost(75)

func enable() -> void:
	Micro.player.bullet_size_mult += 0.3
	Micro.player.bullet_damage_mult *= 1.1
	Micro.player.bullet_velocity_mult *= 0.85
	Micro.player.bullet_lifetime_mult *= 1.1

func disable() -> void:
	Micro.player.bullet_size_mult -= 0.3
	Micro.player.bullet_damage_mult /= 1.1
	Micro.player.bullet_velocity_mult /= 0.85
	Micro.player.bullet_lifetime_mult /= 1.1
