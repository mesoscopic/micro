extends Upgrade
class_name EvasionUpgrade

func _init() -> void:
	title = "Evasion"
	description = "Move 25% faster when not shooting\nFaster acceleration and deceleration"
	render = ShaderMaterial.new()
	render.shader = preload("res://entities/player/upgrades/evasion.gdshader")
	set_cost(40)

func enable() -> void:
	Micro.player.evasion_mult *= 1.25
	Micro.player.acceleration *= 1.25
	Micro.player.deceleration *= 1.25

func disable() -> void:
	Micro.player.evasion_mult /= 1.25
	Micro.player.acceleration /= 1.25
	Micro.player.deceleration /= 1.25
