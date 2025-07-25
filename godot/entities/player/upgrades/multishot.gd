extends Upgrade
class_name MultishotUpgrade

func _init() -> void:
	title = "Multishot"
	description = "+2 bullets every shot, -33% bullet damage"
	render = ShaderMaterial.new()
	render.shader = preload("res://entities/player/upgrades/multishot.gdshader")
	set_cost(100)

func enable() -> void:
	Micro.player.multishot += 1
	Micro.player.bullet_damage_mult /= 1.5
	Micro.player.reset_bullets()

func disable() -> void:
	Micro.player.multishot -= 1
	Micro.player.bullet_damage_mult *= 1.5
	Micro.player.reset_bullets()
