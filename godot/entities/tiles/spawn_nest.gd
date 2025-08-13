extends Node2D

var tween: Tween
var purchased_upgrade: Upgrade

func _ready() -> void:
	Micro.world.purchase_upgrade.connect(func (item: Upgrade):
		await Micro.wait(0.5)
		purchased_upgrade = item
	)

func _on_home_zone_entered(_body: Node2D) -> void:
	for i in ceil((Micro.player.max_hp - Micro.player.hp)/5.*randf_range(1.,2.)):
		var orb := preload("res://misc/effects/HealOrb.tscn").instantiate()
		orb.position = position
		orb.distance = randf_range(40.,80.)
		Micro.world.get_node("Entities").add_child(orb)
