extends Node2D

var tween: Tween
var purchased_upgrade: Upgrade

func _ready() -> void:
	Micro.world.purchase_upgrade.connect(func (item: Upgrade):
		activate()
		await Micro.wait(0.5)
		purchased_upgrade = item
		)

func _on_home_zone_entered(_body: Node2D) -> void:
	$RegenTimer.start()
	if Micro.player.hp < Micro.player.max_hp: $HealRay.start()
	activate()

func _on_home_zone_exited(_body: Node2D) -> void:
	$RegenTimer.stop()
	deactivate()

func _on_regen() -> void:
	if Micro.player.hp < Micro.player.max_hp:
		Micro.player.heal(1)

func activate() -> void:
	if tween: tween.stop()
	tween = get_tree().create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)
	tween.tween_property($Character, "light", 200, 0.5)

func deactivate() -> void:
	# Deactivated at end of trade "cutscene", so do not deactivate if player is still inside
	if $HomeZone.has_overlapping_bodies(): return
	if tween: tween.stop()
	tween = get_tree().create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)
	tween.tween_property($Character, "light", 0, 0.5)
