extends Upgrade
class_name MultishotUpgrade

func _init() -> void:
	title = "Multishot"
	description = "+2 bullets every shot, -33% bullet damage"
	render = ShaderMaterial.new()
	render.shader = preload("res://shaders/upgrades/multishot.gdshader")
	set_cost(50)

func enable() -> void:
	Micro.player.multishot += 1
	Micro.player.bullet_damage_mult /= 1.5

func disable() -> void:
	Micro.player.multishot -= 1
	Micro.player.bullet_damage_mult *= 1.5
