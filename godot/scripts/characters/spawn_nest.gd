extends Node2D

var tween: Tween

func _on_home_zone_entered(body: Node2D) -> void:
	if body != Micro.player: return
	$RegenTimer.start()
	if tween: tween.stop()
	tween = get_tree().create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)
	tween.tween_property($Character, "light", 200, 0.5)

func _on_home_zone_exited(body: Node2D) -> void:
	if body != Micro.player: return
	$RegenTimer.stop()
	if tween: tween.stop()
	tween = get_tree().create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)
	tween.tween_property($Character, "light", 0, 0.5)

func _on_regen() -> void:
	if Micro.player.hp < Micro.player.max_hp:
		Micro.player.heal(1)
