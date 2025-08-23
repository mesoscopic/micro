extends Upgrade
class_name VitalityUpgrade

func _init() -> void:
	title = "Vitality"
	description = "+20% health"
	render = ShaderMaterial.new()
	render.shader = preload("res://entities/player/upgrades/vitality.gdshader")
	set_cost(75)

func enable() -> void:
	Micro.player.max_hp += 20
	Micro.player.heal(20)

func disable() -> void:
	Micro.player.max_hp -= 20
	Micro.player.heal(20)
