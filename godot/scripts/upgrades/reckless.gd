extends Upgrade
class_name RecklessUpgrade

func _init() -> void:
	title = "Reckless"
	description = "-20% recharge time, +5° spread"
	render = ShaderMaterial.new()
	render.shader = preload("res://shaders/upgrades/reckless.gdshader")
	set_cost(60)

func enable() -> void:
	Micro.player.shoot_cooldown_mult *= 0.8
	Micro.player.bullet_spread += PI/36.

func disable() -> void:
	Micro.player.shoot_cooldown_mult /= 0.8
	Micro.player.bullet_spread -= PI/36.
