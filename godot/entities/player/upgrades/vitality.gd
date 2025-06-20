extends Upgrade
class_name VitalityUpgrade

func _init() -> void:
	title = "Vitality"
	description = "+15% health"
	render = ShaderMaterial.new()
	render.shader = preload("res://entities/player/upgrades/vitality.gdshader")
	set_cost(75)

func enable() -> void:
	Micro.player.max_hp += 15
	Micro.player.set_hp(Micro.player.max_hp)

func disable() -> void:
	Micro.player.max_hp -= 15
	Micro.player.set_hp(Micro.player.max_hp)
