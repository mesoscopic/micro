extends Upgrade
class_name EvasionUpgrade

func _init() -> void:
	title = "Evasion"
	description = "+25% max velocity when not recharging\nFaster acceleration and deceleration"
	render = ShaderMaterial.new()
	render.shader = preload("res://shaders/upgrades/evasion.gdshader")
	set_cost(45)

func enable() -> void:
	Micro.player.evasion_mult *= 1.25
	Micro.player.acceleration *= 1.25
	Micro.player.deceleration *= 1.25

func disable() -> void:
	Micro.player.evasion_mult /= 1.25
	Micro.player.acceleration /= 1.25
	Micro.player.deceleration /= 1.25
