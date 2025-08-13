extends Upgrade
class_name RecklessnessUpgrade

func _init() -> void:
	title = "Recklessness"
	description = "-20% recharge time, +5° spread"
	render = ShaderMaterial.new()
	render.shader = preload("res://entities/player/upgrades/recklessness.gdshader")
	set_cost(60)

func enable() -> void:
	Micro.player.shoot_cooldown_mult *= 0.8
	Micro.player.bullet_spread += PI/36.

func disable() -> void:
	Micro.player.shoot_cooldown_mult /= 0.8
	Micro.player.bullet_spread -= PI/36.
