extends Node2D

var tween: Tween
var purchased_upgrade: Upgrade

func _ready() -> void:
	Micro.world.purchase_upgrade.connect(func (item: Upgrade):
		await Micro.wait(0.5)
		purchased_upgrade = item
	)

func _on_home_zone_entered(_body: Node2D) -> void:
	$RegenTimer.start()
	if Micro.player.hp < Micro.player.max_hp: $HealRay.heal(Micro.player, Micro.player.max_hp, 1.)

func _on_home_zone_exited(_body: Node2D) -> void:
	$RegenTimer.stop()

func _on_regen() -> void:
	if Micro.player.hp < Micro.player.max_hp:
		Micro.player.heal(1)
